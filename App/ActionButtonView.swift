import SwiftUI

struct ActionButtonView: View {
    let title: String
    let icon: String
    let action: () -> Void
    var isDestructive: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                Text(title)
                    .fontWeight(.semibold)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(12)
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isDestructive ? Color.red : Color.accentColor)
            )
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        ActionButtonView(
            title: "Sign App",
            icon: "checkmark.circle.fill",
            action: { }
        )
        ActionButtonView(
            title: "Delete",
            icon: "trash.fill",
            action: { },
            isDestructive: true
        )
    }
    .padding()
}
