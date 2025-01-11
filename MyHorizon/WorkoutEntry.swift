import SwiftUI

struct WorkoutEntry: View {
    var body: some View {
        HStack(alignment: .bottom) {
            icon
            description
            Spacer()
            date
        }
    }
    
    var icon: some View {
        Image(systemName: "figure.walk")
            .imageScale(.large)
            .padding(13)
            .background(in: Circle())
            .backgroundStyle(.tertiary)
            .foregroundStyle(.green)
    }
    
    var description: some View {
        VStack(alignment: .leading) {
            Text("Outdoor Walk")
            Text("10.00KM")
                .bold()
                .foregroundStyle(.green)
                .font(.title2)
        }
    }
    
    var date: some View {
        Text("Yesteraday")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
}

#Preview {
    WorkoutEntry()
}
