import SwiftUI

struct DistanceGauge: View {
    @State private var distance = 1.7
    @State private var progress: Angle = .degrees(181)
    @State private var distanceGoal = 10.2
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                ArchShape(endAngle: .degrees(0))
                    .stroke(.secondary, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .aspectRatio(2, contentMode: .fit)
                    .padding()
                ArchShape(endAngle: progress)
                    .stroke(.red, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .aspectRatio(2, contentMode: .fit)
                    .padding()
                Text("\(distance.formatted()) KM / \(distanceGoal.formatted(.number)) KM")
                    .font(.title)
                    .fontDesign(.monospaced)
                    .contentTransition(.numericText())
                    .padding(.bottom)
            }
            .background(in: RoundedRectangle(cornerRadius: 8))
            .backgroundStyle(.ultraThinMaterial)
            
            Button("Update") {
                withAnimation(.linear(duration: 29)) {
                    progress = .degrees(270)
                }
            }
        }
    }
}

struct ArchShape: Shape {
    var endAngle: Angle
    
    var animatableData: Angle {
        get { endAngle }
        set { endAngle = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = rect.height
        let center = CGPoint(x: rect.midX, y: rect.maxY)
        
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(180),
            endAngle: endAngle,
            clockwise: false
        )
        return path
    }
}

#Preview {
    DistanceGauge()
}
