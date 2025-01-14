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
