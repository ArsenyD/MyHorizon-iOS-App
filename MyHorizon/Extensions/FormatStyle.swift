import Foundation

extension FormatStyle where Self == Measurement<UnitLength>.FormatStyle {
    static var walkingDistance: Measurement<UnitLength>.FormatStyle {
        Measurement<UnitLength>.FormatStyle(width: .narrow, numberFormatStyle: .number.precision(.fractionLength(2)))
    }
    
}

extension FormatStyle where Self == Measurement<UnitEnergy>.FormatStyle {
    static var burnedCalories: Measurement<UnitEnergy>.FormatStyle {
        Measurement<UnitEnergy>.FormatStyle(width: .abbreviated, usage: .workout, numberFormatStyle: .number.rounded())
    }
}
