import SwiftUI

struct WorkoutRow: View {
    let distance: Measurement<UnitLength>?
    let date: Date
    
    private var dateStyle: Date.FormatStyle {
        Date.FormatStyle()
            .day(.twoDigits)
            .month(.twoDigits)
            .year(.twoDigits)
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            iconComponent
            descriptionComponent
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
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
            Text(distance?.formatted(.walkingDistance).uppercased() ?? "N/A")
                .bold()
                .foregroundStyle(.green)
                .font(.title2)
        }
    }
    
    var dateComponent: some View {
        Text(date.formatted(dateStyle))
            .font(.caption)
            .foregroundStyle(.secondary)
    }
}

#Preview {
    WorkoutRow(distance: .previewValue, date: Date())
}
