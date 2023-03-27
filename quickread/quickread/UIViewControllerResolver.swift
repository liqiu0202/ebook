import SwiftUI
import UIKit

struct UIViewControllerResolver: UIViewRepresentable {
    @Binding var parentViewController: UIViewController?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            self.parentViewController = context.coordinator.parentViewController
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    class Coordinator: NSObject {
        var parentViewController: UIViewController?
        init(_ resolver: UIViewControllerResolver) {
            super.init()
            parentViewController = findViewController(UIApplication.shared.windows.first!.rootViewController)
        }

        func findViewController(_ controller: UIViewController?) -> UIViewController? {
            if let navigationController = controller as? UINavigationController {
                return findViewController(navigationController.visibleViewController)
            } else if let tabBarController = controller as? UITabBarController {
                return findViewController(tabBarController.selectedViewController)
            } else if let presentedController = controller?.presentedViewController {
                return findViewController(presentedController)
            } else {
                return controller
            }
        }
    }
}
