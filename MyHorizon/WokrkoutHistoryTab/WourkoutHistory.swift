import SwiftUI

struct WourkoutHistory: View {
    @Environment(HealthKitManager.self) var healthKitManager
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(healthKitManager.walkWorkouts) { walkSession in
                    NavigationLink {
                        WorkoutDetailView(workout: walkSession)
                    } label: {
                        WorkoutRow(distance: walkSession.measuredDistanceWalkingRunning, date: walkSession.endDate)
                    }
                }
                .navigationTitle("Workouts")
            }
            .listStyle(.plain)
        }
        .task {
            await healthKitManager.retrieveWalkWorkouts()
        }
    }
}

#Preview {
    WourkoutHistory()
        .environment(HealthKitManager())
}
