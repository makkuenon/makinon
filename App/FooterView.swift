import SwiftUI

struct FooterView: View {
    var body: some View {
        VStack(spacing: 8) {
            Divider()
                .padding(.vertical, 8)
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Makinon iOS Signer")
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text("v1.0.0")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    Link(destination: URL(string: "https://github.com/makkuenon/makinon")!) {
                        Image(systemName: "link")
                            .font(.caption)
                    }
                    
                    Link(destination: URL(string: "https://makkuenon.github.io/makinon/")!) {
                        Image(systemName: "globe")
                            .font(.caption)
                    }
                }
                .foregroundColor(.accentColor)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    FooterView()
}
