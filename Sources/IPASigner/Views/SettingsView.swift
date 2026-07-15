import SwiftUI

struct SettingsView: View {
    @AppStorage("outputDirectory") var outputDirectory: String = ""
    @AppStorage("autoSaveEnabled") var autoSaveEnabled: Bool = true
    @AppStorage("debugLogging") var debugLogging: Bool = false
    @State private var showingFolderPicker = false
    
    var body: some View {
        VStack(spacing: 20) {
            Form {
                Section("Output Settings") {
                    HStack {
                        Text("Output Directory")
                        Spacer()
                        if !outputDirectory.isEmpty {
                            Text(outputDirectory)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Button(action: { showingFolderPicker = true }) {
                        HStack {
                            Image(systemName: "folder")
                            Text("Browse")
                        }
                    }
                }
                
                Section("Signing Options") {
                    Toggle("Auto-save signed IPA", isOn: $autoSaveEnabled)
                }
                
                Section("Developer Options") {
                    Toggle("Debug Logging", isOn: $debugLogging)
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Swift Version")
                        Spacer()
                        Text("5.9+")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    SettingsView()
}
