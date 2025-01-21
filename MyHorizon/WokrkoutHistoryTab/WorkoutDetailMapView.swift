import SwiftUI
import MapKit

struct WorkoutDetailMapView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Map")
                .bold()
                .font(.title2)
            Map {
                
            }
            .frame(width: 350, height: 250)
            .padding(15)
            .background(in: RoundedRectangle(cornerRadius: 8))
            .backgroundStyle(.bar)
        }
    }
}

#Preview {
    WorkoutDetailMapView()
}
