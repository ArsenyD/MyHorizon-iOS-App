import SwiftUI
import HealthKit
import MapKit

struct WorkoutDetailView: View {
    
    @Environment(HealthKitManager.self) var healthKitManager
    let workout: HKWorkout

    @State private var workoutLocations: [CLLocation] = []
    @State private var mapCameraPositon: MapCameraPosition = .automatic
    
    private var walkDurationFormatted: String {
        let hours = Int(workout.measuredWalkDuration.converted(to: .hours).value)
        let minutes = Int(workout.measuredWalkDuration.converted(to: .minutes).value) - hours * 60
        let seconds = Int(workout.measuredWalkDuration.value) - (minutes * 60) - (hours * 3600)
        
        // TODO: - Refactor later
        let minutesString = minutes < 10 ? String("0\(minutes)") : String("\(minutes)")
        let secondsString = seconds < 10 ? String("0\(seconds)") : String("\(seconds)")
        
        return "\(hours):\(minutesString):\(secondsString)"
    }
    
    private var navigationTitlteDateFormat: Date.FormatStyle {
        Date.FormatStyle()
            .year(.omitted)
            .month(.abbreviated)
            .weekday(.abbreviated)
            .day(.defaultDigits)
            .hour(.omitted)
            .minute(.omitted)
    }
    
    private var averageHeartRateFormatted: String {
        guard let measuredHeartRate = workout.measuredAverageHeartRate else { return "N/A" }
        
        return "\(measuredHeartRate) BPM"
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                header
                statistics
                workoutMap
            }
            .navigationTitle(workout.endDate.formatted(navigationTitlteDateFormat))
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            Task {
                do {
                    self.workoutLocations = try await healthKitManager.retrieveWorkoutRoute(for: workout)
                } catch {
                    fatalError("Error while fetching workout route: \(error)")
                }
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
                    Label("N/A", systemImage: "location.fill")
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
            Text("N/A")
                .foregroundStyle(Color(red: 0.651, green: 0.996, blue: 0.478))
                .font(.title)
        }
    }
    
    var averagePace: some View {
        VStack(alignment: .leading) {
            Text("Avg.Pace")
            Text("N/A")
                .foregroundStyle(.cyan)
                .font(.title)
        }
    }
    
    var averageHeartRate: some View {
        VStack(alignment: .leading) {
            Text("Avg. Heart Rate")
            Text(averageHeartRateFormatted)
                .foregroundStyle(.red)
                .font(.title)
        }
    }
    
    @ViewBuilder
    var workoutMap: some View {
        if workoutLocations.isEmpty {
            ProgressView()
        } else {
            VStack(alignment: .leading) {
                Text("Map")
                    .bold()
                    .font(.title2)
                Map {
                    ForEach(workoutLocations, id: \.self) { location in
                        Marker(coordinate: location.coordinate) {
                            Circle()
                                .frame(width: 5, height: 5)
                        }
                    }
                }
                .frame(width: 350, height: 250)
                .padding(15)
                .background(in: RoundedRectangle(cornerRadius: 8))
                .backgroundStyle(.bar)
            }
        }
    }
}
