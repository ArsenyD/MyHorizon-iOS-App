import SwiftUI

@main
struct MyHorizonApp: App {
    @State private var healthKitManager = HealthKitManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(healthKitManager)
        }
    }
}
