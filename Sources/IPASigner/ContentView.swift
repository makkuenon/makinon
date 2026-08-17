import SwiftUI

struct ContentView: View {
    @EnvironmentObject var signingService: IPASigningService
    @State private var showingFilePicker = false
    @State private var selectedIPAPath: String?
    @State private var isProcessing = false
    @State private var selection = 0

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("IPA Signer")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Sign and configure iOS applications")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

                // Main Content
                TabView(selection: $selection) {
                    SmoothHomeView()
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }
                        .tag(0)

                    SigningView()
                        .tabItem {
                            Label("Sign IPA", systemImage: "signature")
                        }
                        .tag(1)

                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                        .tag(2)
                }
                .onAppear {
                    // Make Home the default selected tab
                    selection = 0
                }
                // Listen for requests to open the Signing tab
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("OpenSigningTab"))) { _ in
                    selection = 1
                }

                Spacer()

                // Status Bar
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.blue)
                    Text(statusMessage)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            .padding()
            .navigationTitle("IPA Signer")
        }
    }

    private var statusMessage: String {
        if isProcessing {
            return "Processing..."
        }
        return "Ready to sign IPA files"
    }
}

#Preview {
    ContentView()
        .environmentObject(IPASigningService())
}
