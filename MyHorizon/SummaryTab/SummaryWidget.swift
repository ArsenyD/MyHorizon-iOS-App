import SwiftUI

struct SummaryWidget: View {
    let symbol: String
    let heading: String
    let description: String
    let tint: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Label(heading, systemImage: symbol)
                .font(.title3)
                .bold()
                .padding([.horizontal, .top], 8)
                .padding(.bottom, 4)
            Divider()
                .padding(.bottom, 6)
            Group {
                Text(description)
                    .font(.subheadline)
                Text("17.16KM")
                    .fontDesign(.rounded)
                    .font(.title)
                    .bold()
                    .foregroundStyle(tint)
            }
            .padding(.horizontal, 8)
            WidgetChart()
                .foregroundStyle(tint)
                .padding([.horizontal, .bottom], 8)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 170)
        .background(in: RoundedRectangle(cornerRadius: 18))
        .backgroundStyle(.bar)
    }
}

#Preview {
    SummaryWidget(
        symbol: "figure.walk",
        heading: "Distance",
        description: "Weekly Distance",
        tint: .red
    )
}
