import SwiftUI

struct WourkoutHistory: View {
    var body: some View {
        List {
            ForEach(0..<10) { _ in
                WorkoutEntry()
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    WourkoutHistory()
}
