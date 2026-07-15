import SwiftUI

struct ContentView: View {
    @EnvironmentObject var signingService: IPASigningService
    @State private var showingFilePicker = false
    @State private var selectedIPAPath: String?
    @State private var isProcessing = false
    
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
                TabView {
                    SigningView()
                        .tabItem {
                            Label("Sign IPA", systemImage: "signature")
                        }
                    
                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
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
