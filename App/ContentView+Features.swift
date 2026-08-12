import SwiftUI

extension ContentView {
    /// Enhanced content view with footers and features
    var enhancedBody: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text("Makinon iOS Signer")
                        .font(.title)
                        .bold()
                    
                    Text("UIKit + SwiftUI hybrid")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemBackground))
                
                Divider()
                
                // Features
                FeaturesListView()
                
                Spacer()
                
                // Footer
                FooterView()
            }
        }
    }
}
