import UIKit
import HealthKit

let distance = HKQuantity(unit: .meterUnit(with: .kilo), doubleValue: 7.8482184)
let measurment = Measurement<UnitLength>(value: distance.doubleValue(for: .meterUnit(with: .kilo)), unit: .kilometers)

let formatter = Measurement<UnitLength>.FormatStyle(width: .narrow, numberFormatStyle: .number.precision(.fractionLength(2)))
let measurmentFormatted = measurment.formatted(formatter)

print("distance: \(measurmentFormatted)")

let calories = HKQuantity(unit: .largeCalorie(), doubleValue: 780.214)
let measurmentEnergy = Measurement<UnitEnergy>(value: calories.doubleValue(for: .largeCalorie()), unit: .kilocalories)

let energyFormat = Measurement<UnitEnergy>.FormatStyle(width: .wide, usage: .workout, numberFormatStyle: .number.rounded())
let caloriesFormatted = measurmentEnergy.formatted(energyFormat)

print(caloriesFormatted)

let duration: TimeInterval = 6964.234
let measuredDurationSeconds = Measurement<UnitDuration>(value: duration, unit: .seconds)
let measuredDurationMinutes = measuredDurationSeconds.converted(to: .minutes)
let measuredDurationHours = measuredDurationSeconds.converted(to: .hours)

let string = "\(measuredDurationHours.formatted()):\(measuredDurationMinutes.formatted()):\(measuredDurationSeconds.formatted())"
print(string)

