import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Summary", systemImage: "heart.text.clipboard") {
                SummaryTab()
            }
            
            Tab("History", systemImage: "figure.run.square.stack") {
                WourkoutHistory()
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(HealthKitManager())
}
