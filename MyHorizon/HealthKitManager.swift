import Foundation
import HealthKit
import OSLog


private let logger = Logger(subsystem: "com.ArsenyD.MyHorizon", category: "HealthKitManager")

@Observable
class HealthKitManager {
    private var healthStore: HKHealthStore?
    private let requiredHKTypes: Set = [
        HKQuantityType.workoutType()
    ]
    
    var walkWorkouts: [HKWorkout] = []
    
    // W.I.P
    func retrieveWalkWorkouts() async {
        guard let store = healthStore else {
            logger.warning("healthStore is nil. Terminating `retrieveWalkWorkouts()` method ")
            return
        }
        
        let onlyWalkWorkouts = HKQuery.predicateForWorkouts(with: .walking)
        
        let query = HKSampleQueryDescriptor(
            predicates: [.sample(type: .workoutType(), predicate: onlyWalkWorkouts)],
            sortDescriptors: [SortDescriptor(
                \.endDate,
                 order: .reverse
            )],
            limit: 10
        )
        
        do {
            let results = try await query.result(for: store)
            logger.log("Got \(results.count) results for the query.")
            
            guard let walks = results as? [HKWorkout] else {
                logger.warning("Type Casting from [HKSample] to [HKWorkout] failed. No results will be returned.")
                return
            }
            
            walkWorkouts = walks
            
        } catch {
            logger.warning("Query failed. No results will be returned.")
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
