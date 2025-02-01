import SwiftUI

struct SummaryTab: View {
    var dateFormat: Date.FormatStyle {
        Date.FormatStyle()
            .weekday(.wide)
            .month(.abbreviated)
            .day(.twoDigits)
    }
    
    var body: some View {
        NavigationStack {
            Text("Work In Progress")
            .navigationTitle("Summary")
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Text(Date().formatted(dateFormat))
                        .foregroundStyle(.secondary)
                        .padding(.top, 20)
                }
            }
        }
    }
}

#Preview {
    SummaryTab()
}
