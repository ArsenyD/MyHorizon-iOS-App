import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("History", systemImage: "figure.run.square.stack") {
                WourkoutHistory()
            }
            
            Tab("Map", systemImage: "map") {
                WorkoutMap()
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(HealthKitManager())
}
