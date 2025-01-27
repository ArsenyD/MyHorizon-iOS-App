import Foundation
import HealthKit
import MapKit
import OSLog


private let logger = Logger(subsystem: "com.ArsenyD.MyHorizon", category: "HealthKitManager")

@Observable
class HealthKitManager {
    private var healthStore: HKHealthStore?
    private let requiredHKTypes: Set = [
        HKQuantityType.workoutType(),
        HKSeriesType.workoutRoute()
    ]
    
    var walkWorkouts: [HKWorkout] = []
    
    func retrieveWorkoutRoute(for workout: HKWorkout) async throws -> [CLLocation] {
        guard let store = self.healthStore else {
            fatalError("retrieveWorkoutRoute(): healthStore is nil. App is in invalid state.")
        }
        
        // Creating predicate for the workout we need to retrieve the route for
        let currentWorkoutPredicate = HKQuery.predicateForObjects(from: workout)
        
        // Creating the anchored query for route fetching
        let routeSamplesQuery = HKAnchoredObjectQueryDescriptor(predicates: [.workoutRoute(currentWorkoutPredicate)], anchor: nil)
        
        // starting a long-running query. queryResults is of type HKWorkoutRoute
        let queryResults = routeSamplesQuery.results(for: store)
        
        // creating the task
        let task =  Task {
            var workoutRouteLocations: [CLLocation] = []
            
            for try await result in queryResults {
                let routeSamples = result.addedSamples
                
                for routeSample in routeSamples {
                    // creating the route query to access individual locations
                    let routeQueryDescriptor = HKWorkoutRouteQueryDescriptor(routeSample)
                    
                    // starting a route query
                    let locations = routeQueryDescriptor.results(for: store)
                    
                    // accessing individual locations
                    for try await location in locations {
                        workoutRouteLocations.append(location)
                        print(location.coordinate)
                        print("count: \(workoutRouteLocations.count)")
                    }
                }
                
                return workoutRouteLocations
            }
            
            return workoutRouteLocations
        }
        
        return try await task.value
    }
    
    // Try using HKAnchoredQueryDescriptor instead of HKSampleQueryDescriptor
    func retrieveWalkWorkouts() async {
        guard let store = healthStore else {
            fatalError("retrieveWalkWorkouts(): healthStore is nil. App is in invalid state.")
        }
        
        let onlyWalkWorkouts = HKQuery.predicateForWorkouts(with: .walking)
        
        let query = HKSampleQueryDescriptor(
            predicates: [.sample(type: .workoutType(), predicate: onlyWalkWorkouts)],
            sortDescriptors: [SortDescriptor(
                \.endDate,
                 order: .reverse
            )],
            limit: nil
        )
        
        do {
            let results = try await query.result(for: store)
            logger.log("retrieveWalkWorkouts(): Received \(results.count) results.")
            
            guard let walks = results as? [HKWorkout] else {
                // this should never fail
                logger.warning("retrieveWalkWorkouts(): Type Casting from [HKSample] to [HKWorkout] failed. Returning from the method with no results.")
                return
            }
            
            walkWorkouts = walks
            
        } catch {
            logger.warning("retrieveWalkWorkouts(): Query failed. Returning from the method with no results.")
        }
    }
    
    func convertToCityName(location: CLLocation) async -> String? {
        // CLGeocoder is a class that is used to convert from coordinates to user-friendly location names and the other way around.
        let geocoder = CLGeocoder()
        
        if let placemarkArray = try? await geocoder.reverseGeocodeLocation(location) {
            return placemarkArray[0].locality
        } else {
            return nil
        }
    }
    
    init() {
        logger.log("initializing HealthKitManager")
        
        if HKHealthStore.isHealthDataAvailable() {
            self.healthStore = HKHealthStore()
            logger.log("Health data is available on the current device. Created HKHealthStore.")
            
            Task {
                do {
                    logger.log("Requesting authorization for health data.")
                    try await healthStore?.requestAuthorization(toShare: [], read: requiredHKTypes)
                } catch {
                    fatalError("Authorization Request Failed")
                }
                
                logger.log("Successfully requested access to health data.")
            }
            
        } else {
            fatalError("HealthKit isn't available on current device")
        }
    }
}
