import Foundation
import HealthKit

extension HKWorkout: @retroactive Identifiable {
    public var id: UUID {
        self.uuid
    }
}

extension HKWorkout {
    var measuredDistanceWalkingRunning: Measurement<UnitLength>? {
        guard let double = self.statistics(for: HKQuantityType(.distanceWalkingRunning))?.sumQuantity()?.doubleValue(for: .meterUnit(with: .kilo)) else { return nil }
        return .init(value: double, unit: .kilometers)
    }
    
    var measuredActiveCalories: Measurement<UnitEnergy>? {
        guard let double = self.statistics(for: HKQuantityType(.activeEnergyBurned))?.sumQuantity()?.doubleValue(for: .largeCalorie()) else { return nil }
        return .init(value: double, unit: .kilocalories)
    }
    
    var measuredTotalCalories: Measurement<UnitEnergy>? {
        guard let restingCaloriesDouble = self.statistics(for: HKQuantityType(.basalEnergyBurned))?.sumQuantity()?.doubleValue(for: .largeCalorie()) else { return nil }
        guard let activeCaloriesDouble = measuredActiveCalories else { return nil }
        return .init(value: restingCaloriesDouble + activeCaloriesDouble.value, unit: .kilocalories)
    }
    
    var measuredWalkDuration: Measurement<UnitDuration> {
        .init(value: self.duration, unit: .seconds)
    }
    
    var measuredAverageHeartRate: Int? {
        guard let double = self.statistics(for: .init(.heartRate))?.averageQuantity()?.doubleValue(for: HKUnit(from: "count/min")) else { return nil }
        return Int(double)
    }
    
    var elevation: Measurement<UnitLength>? {
        guard let metadata = self.metadata else { return nil }
        
        let elevationAscended = metadata[HKMetadataKeyElevationAscended]
        
        if let elev = elevationAscended as? HKQuantity {
            let measurementCM = Measurement<UnitLength>(value: elev.doubleValue(for: HKUnit(from: "cm")), unit: .centimeters)
            let measurementInMeters = measurementCM.converted(to: .meters)
            return measurementInMeters
        } else {
            return nil
        }
    }
}
