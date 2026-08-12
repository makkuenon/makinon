import SwiftUI

struct FeatureCardView: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
            }
            
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(3)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .stroke(Color(.separator), lineWidth: 1)
        )
    }
}

#Preview {
    FeatureCardView(
        icon: "checkmark.circle.fill",
        title: "Fast Signing",
        description: "Sign your iOS apps quickly and efficiently",
        color: .green
    )
}
