import SwiftUI

struct WorkoutEntry: View {
    let distance: Measurement<UnitLength>?
    let date: Date
    private var distanceFormatted: String {
        guard let distance else { return "N/A" }
        
        return distance.formatted().uppercased()
    }
    
    var body: some View {
        HStack(alignment: .bottom) {
            iconComponent
            descriptionComponent
            Spacer()
            dateComponent
        }
    }
    
    var iconComponent: some View {
        Image(systemName: "figure.walk")
            .imageScale(.large)
            .padding(13)
            .background(in: Circle())
            .backgroundStyle(.tertiary)
            .foregroundStyle(.green)
    }
    
    var descriptionComponent: some View {
        VStack(alignment: .leading) {
            Text("Outdoor Walk")
            Text(distanceFormatted)
                .bold()
                .foregroundStyle(.green)
                .font(.title2)
        }
    }
    
    var dateComponent: some View {
        Text(date, format: .dateTime)
            .font(.caption)
            .foregroundStyle(.secondary)
    }
}

#Preview {
    WorkoutEntry(distance: .previewValue, date: Date())
}
