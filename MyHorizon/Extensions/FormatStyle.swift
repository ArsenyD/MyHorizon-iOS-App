import Foundation

extension FormatStyle where Self == Measurement<UnitLength>.FormatStyle {
    static var walkingDistance: Measurement<UnitLength>.FormatStyle {
        .init(
            width: .narrow,
            numberFormatStyle: .number.precision(.fractionLength(2))
        )
    }
    
    static var elevation: Measurement<UnitLength>.FormatStyle {
        .init(
            width: .narrow,
            numberFormatStyle: .number.rounded(rule: .toNearestOrAwayFromZero).precision(.fractionLength(0))
        )
    }
    
}

extension FormatStyle where Self == Measurement<UnitEnergy>.FormatStyle {
    static var burnedCalories: Measurement<UnitEnergy>.FormatStyle {
        .init(
            width: .abbreviated,
            usage: .workout,
            numberFormatStyle: .number.rounded(rule: .toNearestOrAwayFromZero)
        )
    }
}
