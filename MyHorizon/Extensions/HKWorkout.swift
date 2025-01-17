import Foundation
import HealthKit

extension HKWorkout {
    var measuredDistanceWalkingRunning: Measurement<UnitLength>? {
        guard let double = self.statistics(for: HKQuantityType(.distanceWalkingRunning))?.sumQuantity()?.doubleValue(for: .meterUnit(with: .kilo)) else { return nil }
        let measurment = Measurement<UnitLength>(value: double, unit: .kilometers)
        return measurment
    }
}
