import SwiftUI

struct WourkoutHistory: View {
    @Environment(HealthKitManager.self) var healthKitManager
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(healthKitManager.walkWorkouts) { walkWorkout in
                        NavigationLink {
                            WorkoutDetailView(workout: walkWorkout)
                        } label: {
                            WorkoutRow(distance: walkWorkout.measuredDistanceWalkingRunning, date: walkWorkout.endDate)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .navigationTitle("Walk History")

                    }
                }
            }
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
