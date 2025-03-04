import Foundation
import HealthKit

extension HKWorkout: @retroactive Identifiable {
    public var id: UUID {
        self.uuid
    }
}

extension HKWorkout {
    /// walk duration
    var measuredWalkDuration: Measurement<UnitDuration>? {
        guard self.workoutActivityType == .walking else { return nil }
        
        return .init(value: self.duration, unit: .seconds)
    }
    
    /// Covered distance during the walking workout
    var measuredDistanceWalkingRunning: Measurement<UnitLength>? {
        guard self.workoutActivityType == .walking else { return nil }
        
        guard let double = self.statistics(for: HKQuantityType(.distanceWalkingRunning))?.sumQuantity()?.doubleValue(for: .meterUnit(with: .kilo)) else { return nil }
        return .init(value: double, unit: .kilometers)
    }
    
    /// average walking pace during a walk workout
    var averagePace: (Int, Int)? {
        guard self.workoutActivityType == .walking else { return nil }
        
        guard let distance = measuredDistanceWalkingRunning, let duration = measuredWalkDuration else { return nil }
        
        let durationSec = duration.value
        let distanceKM = distance.value
        
        let paceInSecondsPerKilometer = durationSec / distanceKM
        let minutes = Int(paceInSecondsPerKilometer) / 60
        let seconds = Int(paceInSecondsPerKilometer) % 60
        
        return (minutes, seconds)
    }
    
    /// reached elevation
    var measuredWalkingElevationGain: Measurement<UnitLength>? {
        guard self.workoutActivityType == .walking else { return nil }
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
    
    /// average heart rate during walk workout
    var measuredAverageHeartRate: Int? {
        guard let double = self.statistics(for: .init(.heartRate))?.averageQuantity()?.doubleValue(for: HKUnit(from: "count/min")) else { return nil }
        return Int(double)
    }
    
    /// burned active calories
    var measuredActiveCaloriesBurned: Measurement<UnitEnergy>? {
        guard let double = self.statistics(for: HKQuantityType(.activeEnergyBurned))?.sumQuantity()?.doubleValue(for: .largeCalorie()) else { return nil }
        return .init(value: double, unit: .kilocalories)
    }
    
    /// burned active calories + resting energy
    var measuredTotalCaloriesBurned: Measurement<UnitEnergy>? {
        guard let restingCaloriesDouble = self.statistics(for: HKQuantityType(.basalEnergyBurned))?.sumQuantity()?.doubleValue(for: .largeCalorie()) else { return nil }
        guard let activeCaloriesDouble = measuredActiveCaloriesBurned else { return nil }
        return .init(value: restingCaloriesDouble + activeCaloriesDouble.value, unit: .kilocalories)
    }
}
