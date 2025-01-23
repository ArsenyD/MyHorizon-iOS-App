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
    
//    W.I.P
    func retrieveWorkoutRoute(for workout: HKWorkout) async throws -> [CLLocation] {
        guard let store = self.healthStore else {
            fatalError("retrieveWorkoutRoute(): healthStore is nil. App is in invalid state.")
        }
        
        var workoutRouteLocations: [CLLocation] = []
        
        let walkingObjectQuery = HKQuery.predicateForObjects(from: workout)
        let routeQuery = HKAnchoredObjectQueryDescriptor(predicates: [.workoutRoute(walkingObjectQuery)], anchor: nil)
        
        let queryResults = routeQuery.results(for: store)
        
        for try await result in queryResults {
            let routeSamples = result.addedSamples
            for routeSample in routeSamples {
                let routeQueryDescriptor = HKWorkoutRouteQueryDescriptor(routeSample)
                let locations = routeQueryDescriptor.results(for: store)
                
                for try await location in locations {
                    workoutRouteLocations.append(location)
                    print(workoutRouteLocations.count)
                    return workoutRouteLocations
                }
            }
        }
        
        return workoutRouteLocations
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
            logger.log("retrieveWalkWorkouts(): Received \(results.count) results for query.")
            
            guard let walks = results as? [HKWorkout] else {
                logger.warning("retrieveWalkWorkouts(): Type Casting from [HKSample] to [HKWorkout] failed. Returning from the method with no results.")
                return
            }
            
            walkWorkouts = walks
            
        } catch {
            logger.warning("retrieveWalkWorkouts(): Query failed. Returning from the method with no results.")
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
