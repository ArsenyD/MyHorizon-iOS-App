import SwiftUI
import HealthKit

struct WorkoutDetailView: View {
    let workout: HKWorkout
    
    private var walkDurationFormatted: String {
        let hours = Int(workout.measuredWalkDuration.converted(to: .hours).value)
        let minutes = Int(workout.measuredWalkDuration.converted(to: .minutes).value) - hours * 60
        let seconds = Int(workout.measuredWalkDuration.value) - (minutes * 60) - (hours * 3600)
        
        return "\(hours):\(minutes):\(seconds)"
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                header
                    .padding()
                statistics
                    .padding(.horizontal)
            }
        }
    }
    
    var header: some View {
        HStack {
            Image(systemName: "figure.walk")
                .font(.system(size: 45))
                .padding(25)
                .background(in: Circle())
                .backgroundStyle(.tertiary)
                .foregroundStyle(.green)
            
            VStack(alignment: .leading, spacing: 15) {
                VStack(alignment: .leading) {
                    Text("Outdoor Walk")
                    Text("Open Goal")
                        .foregroundStyle(.green)
                }
                
                VStack(alignment: .leading) {
                    Text("\(workout.startDate.formatted(date: .omitted, time: .shortened))—\(workout.endDate.formatted(date: .omitted, time: .shortened))")
                    Label("Saint Petersburg", systemImage: "location.fill")
                }
                .imageScale(.small)
                .font(.callout)
                .foregroundStyle(.secondary)
            }
        }
    }
    
    var statistics: some View {
        VStack(alignment: .leading) {
            Text("Workout Details")
                .bold()
                .font(.title2)
            Grid(alignment: .leading) {
                GridRow {
                    workoutTime
                    distance
                }
                Divider()
                GridRow {
                    activeCalories
                    totalCalories
                }
                Divider()
                GridRow {
                    elevationGain
                    averagePace
                }
                Divider()
                GridRow {
                    averageHeartRate
                }
            }
            .padding(15)
            .background(in: RoundedRectangle(cornerRadius: 8))
            .backgroundStyle(.bar)
        }
    }
    
    var workoutTime: some View {
        VStack(alignment: .leading) {
            Text("Workout Time")
            Text(walkDurationFormatted)
                .foregroundStyle(.yellow)
                .font(.title)
        }
    }
    
    var distance: some View {
        VStack(alignment: .leading) {
            Text("Distance")
            Text(workout.measuredDistanceWalkingRunning?.formatted(.walkingDistance).uppercased() ?? "N/A")
                .foregroundStyle(.blue)
                .font(.title)
        }
    }
    
    var activeCalories: some View {
        VStack(alignment: .leading) {
            Text("Active Calories")
            Text(workout.measuredActiveCalories?.formatted(.burnedCalories).uppercased() ?? "N/A")
                .foregroundStyle(.pink)
                .font(.title)
        }
    }
    
    var totalCalories: some View {
        VStack(alignment: .leading) {
            Text("Total Calories")
            Text(workout.measuredTotalCalories?.formatted(.burnedCalories).uppercased() ?? "N/A")
                .foregroundStyle(.pink)
                .font(.title)
        }
    }
    var elevationGain: some View {
        VStack(alignment: .leading) {
            Text("Elevation Gain")
            Text("82 M")
                .foregroundStyle(Color(red: 0.651, green: 0.996, blue: 0.478))
                .font(.title)
        }
    }
    
    var averagePace: some View {
        VStack(alignment: .leading) {
            Text("Avg.Pace")
            Text("16'38\"/KM")
                .foregroundStyle(.cyan)
                .font(.title)
        }
    }
    
    var averageHeartRate: some View {
        VStack(alignment: .leading) {
            Text("Avg. Heart Rate")
            Text("107 BPM")
                .foregroundStyle(.red)
                .font(.title)
        }
    }
}
