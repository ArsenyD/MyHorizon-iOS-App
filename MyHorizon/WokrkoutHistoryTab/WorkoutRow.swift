import SwiftUI

struct WorkoutRow: View {
    let distance: Measurement<UnitLength>?
    let date: Date
    
    var distanceFormatted: String {
        distance?.formatted(.walkingDistance).uppercased() ?? "N/A"
    }
    
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
        .padding(.horizontal, 5)
    }
    
    // MARK: - Components
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
                .foregroundStyle(.accent)
                .font(.title)
        }
    }
    
    var dateComponent: some View {
        Text(formattedDate(for: date))
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    
    // Method to properly format date for dateComponent.
    // Either returns explicit "Today"/"Yesterday", date formatted with weekday only (if the workout was in the last 7 days) or date formatted with month, day and year written with 2 digits
    func formattedDate(for date: Date) -> String  {
        let calendar = Calendar.current
        let today = Date()
        
        guard !calendar.isDateInToday(date) else {
            return "Today"
        }
        
        guard !calendar.isDateInYesterday(date) else {
            return "Yesterday"
        }
        
        if let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: today) {
            let lastWeek = DateInterval(start: sevenDaysAgo, end: today)
            
            if lastWeek.contains(date) {
                let weekDayOnlyFormatStyle = Date.FormatStyle()
                    .weekday(.wide)
                return date.formatted(weekDayOnlyFormatStyle)
            } else {
                let twoDigitFormatStyle = Date.FormatStyle()
                    .day(.twoDigits)
                    .month(.twoDigits)
                    .year(.twoDigits)
                return date.formatted(twoDigitFormatStyle)
            }
            
        } else {
            fatalError("formattedDate(for:) method failed")
        }
    }
}

#Preview {
    WorkoutRow(distance: .previewValue, date: Calendar(identifier: .gregorian).date(byAdding: .day, value: -1, to: Date())!)
}
