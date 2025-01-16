import Foundation
import HealthKit

extension HKWorkout {
    var distanceWalkingRunning: Double? {
        self.statistics(for: HKQuantityType(.distanceWalkingRunning))?.sumQuantity()?.doubleValue(for: .meterUnit(with: .kilo))
    }
}
