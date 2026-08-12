import SwiftUI

struct BadgeView: View {
    let text: String
    let style: BadgeStyle
    
    var body: some View {
        Text(text)
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(style.backgroundColor)
            .foregroundColor(style.foregroundColor)
            .cornerRadius(4)
    }
}

enum BadgeStyle {
    case success
    case warning
    case error
    case info
    
    var backgroundColor: Color {
        switch self {
        case .success:
            return Color.green.opacity(0.2)
        case .warning:
            return Color.orange.opacity(0.2)
        case .error:
            return Color.red.opacity(0.2)
        case .info:
            return Color.blue.opacity(0.2)
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .success:
            return Color.green
        case .warning:
            return Color.orange
        case .error:
            return Color.red
        case .info:
            return Color.blue
        }
    }
}

#Preview {
    HStack(spacing: 8) {
        BadgeView(text: "Active", style: .success)
        BadgeView(text: "Pending", style: .warning)
        BadgeView(text: "Error", style: .error)
        BadgeView(text: "Info", style: .info)
    }
    .padding()
}
