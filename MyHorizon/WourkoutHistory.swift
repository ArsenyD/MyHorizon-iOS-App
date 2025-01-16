import SwiftUI

struct WourkoutHistory: View {
    @Environment(HealthKitManager.self) var healthKitManager
    
    var body: some View {
        List {
            ForEach(healthKitManager.walkWorkouts, id: \.self) { walkSession in
                WorkoutEntry(distance: walkSession.measuredDistanceWalkingRunning)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    WourkoutHistory()
        .environment(HealthKitManager())
}
