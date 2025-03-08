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
            DistanceGauge()
                .navigationTitle("Summary")
                .padding(.horizontal)
            Spacer()
        }
    }
}

#Preview {
    SummaryTab()
        .environment(HealthKitManager())
}
