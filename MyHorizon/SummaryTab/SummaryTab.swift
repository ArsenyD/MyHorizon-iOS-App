import SwiftUI

struct SummaryTab: View {
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
                    HStack {
                        SummaryWidget(symbol: "figure.walk", heading: "Walking", description: "Weekly Distance", tint: .red)
                        SummaryWidget(symbol: "figure.walk", heading: "Walking", description: "Weekly Distance", tint: .yellow)
                    }
                    HStack {
                        SummaryWidget(symbol: "figure.walk", heading: "Walking", description: "Weekly Distance", tint: .green)
                        SummaryWidget(symbol: "figure.walk", heading: "Walking", description: "Weekly Distance", tint: .blue)
                    }
                }
                .navigationTitle("Summary")
            }
        }
    }
}

#Preview {
    SummaryTab()
}
