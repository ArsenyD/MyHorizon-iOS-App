import Foundation
import HealthKit
import OSLog


//private let logger = Logger(subsystem: "com.ArsenyD.MyHorizon", category: "HealthKitManager")

@Observable
class HealthKitManager {
    var healthStore: HKHealthStore?
    let requestedHKTypes: Set = [
        HKQuantityType.workoutType()
    ]
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            self.healthStore = HKHealthStore()
            
            Task {
                do {
                    try await healthStore?.requestAuthorization(toShare: [], read: requestedHKTypes)
                } catch {
                    fatalError("Authorization Request Failed")
                }
            }
            
        } else {
            fatalError("HealthKit isn't available on current device")
        }
    }
}
