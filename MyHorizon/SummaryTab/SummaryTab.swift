import SwiftUI

struct SummaryTab: View {
    @Environment(HealthKitManager.self) private var healthManager
    
    var dateFormat: Date.FormatStyle {
        Date.FormatStyle()
            .weekday(.wide)
            .month(.abbreviated)
            .day(.twoDigits)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    SummaryWidget(
                        symbol: "figure.walk",
                        heading: "Distance",
                        description: "This Week",
                        value: "17.6KM",
                        tint: .red
                    )
                    SummaryWidget(
                        symbol: "clock",
                        heading: "Time Walking",
                        description: "This Week",
                        value: "2 H. 36 Min.",
                        tint: .yellow
                    )
                    SummaryWidget(
                        symbol: "figure.walk.motion",
                        heading: "Pace",
                        description: "This Week",
                        value: "--'--\"/KM",
                        tint: .blue
                    )
                    SummaryWidget(
                        symbol: "chevron.up.2",
                        heading: "Elevation",
                        description: "This Week",
                        value: "78M",
                        tint: .green
                    )
                }
                .navigationTitle("Summary")
            }
        }
    }
}

#Preview {
    SummaryTab()
        .environment(HealthKitManager())
}
