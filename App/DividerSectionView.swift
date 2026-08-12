import SwiftUI

struct DividerSectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .padding(.horizontal, 16)
            
            content
                .background(Color(.systemBackground))
                .cornerRadius(10)
        }
    }
}

#Preview {
    DividerSectionView(title: "Settings") {
        VStack(spacing: 0) {
            SettingsCellView(
                icon: "gear",
                title: "Preferences",
                subtitle: nil,
                value: nil,
                action: nil
            )
            Divider()
            SettingsCellView(
                icon: "info.circle",
                title: "About",
                subtitle: nil,
                value: nil,
                action: nil
            )
        }
    }
    .padding()
}
