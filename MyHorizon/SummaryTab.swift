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
            NavigationLink  {
                Text("Hi")
            } label: {
                Text("Link")
            }
            .navigationTitle("Summary")
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Text(Date().formatted(dateFormat))
                        .foregroundStyle(.secondary)
                }
            }
            .toolbarRole(.navigationStack)

        }
    }
}

#Preview {
    SummaryTab()
}
