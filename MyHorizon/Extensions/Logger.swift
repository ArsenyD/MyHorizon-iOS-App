import Foundation
import OSLog

extension Logger {
    static let subsystem = "com.ArsenyD.MyHorizon"
    
    enum Category: String {
        case healthKitManager = "HealthKitManager"
        case workoutHistoryManager = "WorkoutHistoryManager"
        case summaryManager = "SummaryManager"
    }
}
