import SwiftUI

@main
struct MakinonApp: App {
    var body: some Scene {
        WindowGroup {
            RootViewControllerRepresentable()
        }
    }
}

struct RootViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return RootViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
