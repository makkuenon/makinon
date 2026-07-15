import SwiftUI
import UniformTypeIdentifiers

struct SigningView: View {
    @EnvironmentObject var signingService: IPASigningService
    @State private var selectedIPAPath: String?
    @State private var ipaFile: IPAFile?
    @State private var selectedCertificate: String = ""
    @State private var selectedProfile: String = ""
    @State private var isProcessing = false
    @State private var statusMessage = ""
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 16) {
            // File Selection
            VStack(alignment: .leading, spacing: 8) {
                Text("1. Select IPA File")
                    .font(.headline)
                
                if let ipaPath = selectedIPAPath {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text(URL(fileURLWithPath: ipaPath).lastPathComponent)
                            .lineLimit(1)
                        Spacer()
                        Button(action: { selectedIPAPath = nil }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(8)
                } else {
                    Button(action: { openFilePicker() }) {
                        HStack {
                            Image(systemName: "folder.badge.plus")
                            Text("Select IPA File")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(12)
            
            // Certificate Selection
            VStack(alignment: .leading, spacing: 8) {
                Text("2. Select Certificate")
                    .font(.headline)
                
                Picker("Certificate", selection: $selectedCertificate) {
                    Text("Select a certificate").tag("")
                    ForEach(signingService.availableCertificates, id: \.self) { cert in
                        Text(cert).tag(cert)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(12)
            
            // Provisioning Profile Selection
            VStack(alignment: .leading, spacing: 8) {
                Text("3. Select Provisioning Profile")
                    .font(.headline)
                
                Picker("Profile", selection: $selectedProfile) {
                    Text("Select a profile").tag("")
                    ForEach(signingService.availableProfiles, id: \.self) { profile in
                        Text(profile).tag(profile)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(12)
            
            // Sign Button
            Button(action: signIPA) {
                if isProcessing {
                    HStack {
                        ProgressView()
                            .scaleEffect(0.8)
                        Text("Signing...")
                    }
                } else {
                    HStack {
                        Image(systemName: "signature")
                        Text("Sign IPA")
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(selectedIPAPath != nil && selectedCertificate != "" && selectedProfile != "" ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(8)
            .disabled(selectedIPAPath == nil || selectedCertificate == "" || selectedProfile == "" || isProcessing)
            
            // Status
            if !statusMessage.isEmpty {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.blue)
                    Text(statusMessage)
                        .font(.caption)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding()
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func openFilePicker() {
        #if os(macOS)
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [UTType(filenameExtension: "ipa") ?? .item]
        panel.begin { response in
            if response == .OK, let url = panel.url {
                selectedIPAPath = url.path
            }
        }
        #endif
    }
    
    private func signIPA() {
        guard let ipaPath = selectedIPAPath else { return }
        
        isProcessing = true
        statusMessage = "Starting signing process..."
        
        Task {
            do {
                let signedPath = try await signingService.signIPA(
                    at: ipaPath,
                    withCertificate: selectedCertificate,
                    andProfile: selectedProfile
                )
                statusMessage = "Successfully signed IPA: \(URL(fileURLWithPath: signedPath).lastPathComponent)"
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
            isProcessing = false
        }
    }
}

#Preview {
    SigningView()
        .environmentObject(IPASigningService())
}
