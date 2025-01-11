import SwiftUI

struct ContentView: View {
    @Environment(HealthKitManager.self) var healthKitManager
    
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
