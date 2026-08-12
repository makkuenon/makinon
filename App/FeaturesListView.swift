import SwiftUI

struct FeaturesListView: View {
    let features = [
        FeatureModel(
            icon: "checkmark.circle.fill",
            title: "Fast Signing",
            description: "Sign your iOS apps quickly and efficiently with optimized performance",
            color: .green
        ),
        FeatureModel(
            icon: "lock.fill",
            title: "Secure",
            description: "Enterprise-grade security for your provisioning profiles and certificates",
            color: .blue
        ),
        FeatureModel(
            icon: "iphone",
            title: "iOS Native",
            description: "Built with SwiftUI and UIKit for the best native iOS experience",
            color: .purple
        ),
        FeatureModel(
            icon: "gear",
            title: "Configurable",
            description: "Customize signing options to match your development workflow",
            color: .orange
        ),
        FeatureModel(
            icon: "bolt.fill",
            title: "Performant",
            description: "Optimized for speed without compromising on reliability",
            color: .yellow
        ),
        FeatureModel(
            icon: "doc.on.clipboard",
            title: "Batch Operations",
            description: "Process multiple apps in one go and save time",
            color: .red
        )
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(features, id: \.title) { feature in
                    FeatureCardView(
                        icon: feature.icon,
                        title: feature.title,
                        description: feature.description,
                        color: feature.color
                    )
                }
            }
            .padding(16)
        }
    }
}

struct FeatureModel {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

#Preview {
    FeaturesListView()
}
