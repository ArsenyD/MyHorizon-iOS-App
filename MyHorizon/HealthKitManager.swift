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
    
    var latestWalks: [HKSample] = []
    
    // W.I.P
    func getLatestWalks() async {
        guard let store = healthStore else { return }
        
        let onlyWalkWorkoutsPredicate = HKQuery.predicateForWorkouts(with: .walking)
        
        let query = HKSampleQueryDescriptor(
            predicates: [.sample(type: .workoutType(), predicate: onlyWalkWorkoutsPredicate)],
            sortDescriptors: [SortDescriptor(
                \.endDate,
                 order: .reverse
            )],
            limit: nil
        )
        
        do {
            let results = try await query.result(for: store)
            logger.log("Got \(results.count) results for the query")
            latestWalks = results
            logger.log("\(self.latestWalks.first)")
        } catch {
            logger.warning("Query failed")
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
