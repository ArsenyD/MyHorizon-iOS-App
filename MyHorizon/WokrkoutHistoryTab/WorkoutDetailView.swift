import SwiftUI
import HealthKit
import MapKit

struct WorkoutDetailView: View {
    
    @Environment(HealthKitManager.self) var healthKitManager
    let workout: HKWorkout
    
    @State private var workoutLocations: [CLLocation] = []
    @State private var workoutLocality: String? = nil
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
            .padding(.vertical, 5)
            .padding(.horizontal)
            .navigationTitle(workout.endDate.formatted(navigationTitlteDateFormat))
            .navigationBarTitleDisplayMode(.inline)
            .task {
                do {
                    workoutLocations = try await healthKitManager.retrieveWorkoutRoute(for: workout)
                    workoutLocality = await healthKitManager.convertToCityName(
                        location: workoutLocations.last!
                    )
                } catch {
                    fatalError("error while fetching workout route: \(error)")
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
                    if let workoutLocality {
                        Label(workoutLocality, systemImage: "location.fill")
                    }
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
        VStack(alignment: .leading) {
            Text("Map")
                .bold()
                .font(.title2)
            
            if !workoutLocations.isEmpty {
                Map {
                    MapCircle(center: workoutLocations.first!.coordinate, radius: CLLocationDistance(10))
                        .foregroundStyle(.green)
                        .mapOverlayLevel(level: .aboveLabels)
                    
                    MapPolyline(coordinates: workoutLocations.map { $0.coordinate } )
                        .stroke(.accent, lineWidth: 3)
                        .mapOverlayLevel(level: .aboveLabels)
                    
                    MapCircle(center: workoutLocations.last!.coordinate, radius: CLLocationDistance(10))
                        .foregroundStyle(.red)
                        .mapOverlayLevel(level: .aboveLabels)
                }
                .frame(height: 250)
                .frame(minWidth: 0, maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                mapPlaceholder
            }
        }
    }
    
    var mapPlaceholder: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(.placeholder)
            .frame(height: 250)
            .frame(minWidth: 0, maxWidth: .infinity)
            .overlay {
                ProgressView()
            }
    }
}
