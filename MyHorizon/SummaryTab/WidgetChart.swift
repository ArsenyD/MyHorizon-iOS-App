import SwiftUI
import Charts

struct WalkDistance: Identifiable {
    let id = UUID()
    var distance: Double
    var day: String
    
    static var sampleData: [WalkDistance] = [
        .init(distance: 10, day: "Monday"),
        .init(distance: 5.8, day: "Tuesday"),
        .init(distance: 15, day: "Wednesday"),
        .init(distance: 1.5, day: "Thursday"),
        .init(distance: 0, day: "Friday"),
        .init(distance: 18.0, day: "Saturday"),
        .init(distance: 19.7, day: "Sunday"),
    ]
}

struct WidgetChart: View {
    var body: some View {
        Chart(WalkDistance.sampleData) {
            BarMark(
                x: .value("Shape Type", $0.day),
                y: .value("Count", $0.distance)
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .chartXAxis {
            AxisMarks { value in
                AxisValueLabel {
                    if let weekday = value.as(String.self) {
                        Text(weekday.prefix(1))
                    }
                }
                
                AxisTick(stroke: StrokeStyle(lineWidth: 1))
                
                AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
            }
        }
        .chartYAxis(.hidden)
    }
}

#Preview {
    WidgetChart()
}
