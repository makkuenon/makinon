import SwiftUI

@main
struct IPASignerApp: App {
    @StateObject private var signingService = IPASigningService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(signingService)
                .onAppear {
                    setupApp()
                }
        }
        
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
    
    private func setupApp() {
        // Initialize certificate manager
        _ = CertificateManager.shared
    }
}
