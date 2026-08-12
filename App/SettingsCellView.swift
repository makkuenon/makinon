import SwiftUI

struct SettingsCellView: View {
    let icon: String
    let title: String
    let subtitle: String?
    let value: String?
    let action: (() -> Void)?
    
    var body: some View {
        Button(action: action ?? {}) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.accentColor)
                    .frame(width: 28)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                if let value = value {
                    Text(value)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                if action != nil {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color(.systemBackground))
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        SettingsCellView(
            icon: "gear",
            title: "General Settings",
            subtitle: "Configure app behavior",
            value: nil,
            action: { }
        )
        Divider()
        SettingsCellView(
            icon: "bell",
            title: "Notifications",
            subtitle: "Manage alerts",
            value: "On",
            action: nil
        )
    }
    .background(Color(.systemGray6))
}
