import Foundation
import HealthKit
import OSLog

fileprivate let logger = Logger(subsystem: Logger.subsystem, category: Logger.Category.workoutHistoryManager.rawValue)

@Observable
class SummaryManager {
    var healthKitManager: HealthKitManager
    
    // MARK: -  INIT
    init(healthKitManager: HealthKitManager) {
        self.healthKitManager = healthKitManager
    }
}
