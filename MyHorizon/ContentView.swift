import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Summary", systemImage: "heart.text.clipboard") {
                Text("W.I.P")
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
