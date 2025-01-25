import SwiftUI

struct WorkoutRow: View {
    let distance: Measurement<UnitLength>?
    let date: Date
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            iconComponent
            descriptionComponent
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            dateComponent
        }
        .padding(10)
        .background(in: RoundedRectangle(cornerRadius: 8))
        .backgroundStyle(.bar)
        
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
        Text(date.formatted(date: .numeric, time: .omitted))
            .font(.caption)
            .foregroundStyle(.secondary)
    }
}

#Preview {
    WorkoutRow(distance: .previewValue, date: Date())
}
