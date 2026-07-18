import UIKit
import SwiftUI

final class RootViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let content = ContentView()
        let hosting = UIHostingController(rootView: content)

        addChild(hosting)
        hosting.view.frame = view.bounds
        hosting.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(hosting.view)
        hosting.didMove(toParent: self)
    }
}
