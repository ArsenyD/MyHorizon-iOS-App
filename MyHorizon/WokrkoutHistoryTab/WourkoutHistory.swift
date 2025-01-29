import SwiftUI
import HealthKit

struct WourkoutHistory: View {
    @Environment(HealthKitManager.self) var healthKitManager
    @State private var sections: [WorkoutHistorySection] = []
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(pinnedViews: .sectionHeaders) {
                    ForEach(sections, id: \.self) { section in
                        Section {
                            ForEach(section.associatedWorkouts) { workout in
                                NavigationLink {
                                    WorkoutDetailView(workout: workout)
                                } label: {
                                    WorkoutRow(distance: workout.measuredDistanceWalkingRunning, date: workout.endDate)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        } header: {
                            Text(section.yearAndMonth)
                                .font(.title2)
                                .bold()
                                .padding(10)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .background(Color.black)
                        }
                    }
                }
            }
            .navigationTitle("Workout History")
        }
        .task {
            await healthKitManager.retrieveWalkWorkouts()
            sections = createSections(from: healthKitManager.walkWorkouts)
        }
    }
    
    struct WorkoutHistorySection: Hashable {
        let yearAndMonth: String
        
        var associatedWorkouts: [HKWorkout]
        
        init(associatedWorkouts: [HKWorkout]) {
            self.associatedWorkouts = associatedWorkouts
            
            let formatter = Date.FormatStyle()
                .year(.defaultDigits)
                .month(.wide)
            
            let date = associatedWorkouts.last!.endDate
            
            self.yearAndMonth = date.formatted(formatter)
        }
    }
    
    func createSections(from workouts: [HKWorkout]) -> [WorkoutHistorySection] {
        var sections: [WorkoutHistorySection] = []
        var workoutsArray = workouts
        let calendar = Calendar(identifier: .gregorian)
        
        repeat {
            // defining an anchor date by which the array will be filtered
            guard let anchorDate = workoutsArray.first?.endDate else { fatalError("It shouldn't fail") }
            
            // filtering the array
            let filteredByAnchor = workouts.filter { calendar.dateComponents([.year, .month], from: $0.endDate) == calendar.dateComponents([.month, .year], from: anchorDate) }
            
            // initializing and adding section to array
            let sectionToAdd = WorkoutHistorySection(associatedWorkouts: filteredByAnchor)
            sections.append(sectionToAdd)
            
            // removing from the origin array
            workoutsArray.removeAll(where: { calendar.dateComponents([.year, .month], from: $0.endDate) == calendar.dateComponents([.month, .year], from: anchorDate) } )
            
        } while !workoutsArray.isEmpty
        
        return sections
    }
}

#Preview {
    WourkoutHistory()
        .environment(HealthKitManager())
}
