import SwiftUI

struct WorkoutEntry: View {
    var body: some View {
        icon
    }
    
    var icon: some View {
        HStack(alignment: .bottom) {
            Image(systemName: "figure.walk")
                .imageScale(.large)
                .padding(13)
                .background(in: Circle())
                .backgroundStyle(.tertiary)
                .foregroundStyle(.green)
            
            VStack(alignment: .leading) {
                Text("Outdoor Walk")
                Text("10.00KM")
                    .bold()
                    .foregroundStyle(.green)
                    .font(.title2)
            }
            
            Spacer()
            
            Text("Yesteraday")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        
        
    }
}

#Preview {
    WorkoutEntry()
}
