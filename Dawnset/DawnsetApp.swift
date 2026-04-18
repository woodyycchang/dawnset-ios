import SwiftUI

@main
struct DawnsetApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .onAppear {
                    appState.onAppLaunch()
                }
                .preferredColorScheme(.light)
        }
    }
}
