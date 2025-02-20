import Foundation
import HealthKit
import MapKit
import OSLog


private let logger = Logger(subsystem: "com.ArsenyD.MyHorizon", category: "HealthKitManager")

@Observable
class HealthKitManager {
    private var healthStore: HKHealthStore?
    
    // types required for authorization
    private let requiredHKTypes: Set = [
        HKQuantityType.workoutType(),
        HKSeriesType.workoutRoute(),
        HKQuantityType(.walkingSpeed)
    ]
    
    func fetchAverageWalkingSpeed(for workout: HKWorkout) async throws {
        guard let store = healthStore else {
            fatalError("healthStore is nil. App is in invalid state.")
        }
        
        guard let speedType = HKQuantityType.quantityType(forIdentifier: .walkingSpeed) else {
            fatalError("shouldn't fail")
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: workout.startDate, end: workout.endDate, options: .strictStartDate)
        
        let query = HKStatisticsQueryDescriptor(predicate: .quantitySample(type: speedType, predicate: predicate), options: .discreteAverage)
        
        if let result = try await query.result(for: store) {
            let averageSpeed = result.averageQuantity()?.doubleValue(for: HKUnit(from: "m/s"))
            let averagePace = (1.0 / averageSpeed!) * 60.0
            print("Average speed: \(averageSpeed!), pace: \(averagePace)")
        } else {
            throw HKError(.errorNoData)
        }
        
        
    }
    
    // MARK: - Walk Workout Data for WorkoutHistory
    func retrieveWalkWorkouts() async throws -> [HKWorkout]? {
        guard let store = healthStore else {
            throw HKError(.errorHealthDataUnavailable)
        }
        
        let onlyWalkWorkouts = HKQuery.predicateForWorkouts(with: .walking)
        
        // TODO: Try using HKAnchoredQueryDescriptor instead of HKSampleQueryDescriptor
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
                return nil
            }
            
            return walks
        } catch {
            logger.warning("retrieveWalkWorkouts(): Query failed. Returning from the method with no results.")
            return nil
        }
    }
    
    // MARK: - Retrieving Array of locations for specified workout
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
                    }
                }
                
                return workoutRouteLocations
            }
            return workoutRouteLocations
        }
        
        return try await task.value
    }
    
    // MARK: - INIT
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
