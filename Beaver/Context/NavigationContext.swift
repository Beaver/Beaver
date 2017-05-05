#if os(iOS)

import UIKit

public final class NavigationContext: Context {
    public weak var navigationController: UINavigationController!

    let parent: Context

    let animated: Bool

    public typealias NavigationControllerFactory = (UIViewController) -> UINavigationController

    private var navigationControllerFactory: NavigationControllerFactory!

    fileprivate static func navigationControllerFactory(_ rootViewController: UIViewController) -> UINavigationController {
        return UINavigationController(rootViewController: rootViewController)
    }

    public init(parent: Context,
                animated: Bool = true,
                navigationControllerFactory: @escaping NavigationControllerFactory = NavigationContext.navigationControllerFactory) {
        self.parent = parent
        self.animated = animated
        self.navigationControllerFactory = navigationControllerFactory
    }

    public func present(controller: UIViewController, completion: @escaping () -> ()) {
        if let navigationController = navigationController {
            if !navigationController.childViewControllers.contains(controller) {
                return navigationController.push(viewController: controller,
                                                 animated: animated,
                                                 completion: completion)
            } else {
                completion()
            }
        } else {
            let navigationController = navigationControllerFactory(controller)
            navigationControllerFactory = nil
            parent.present(controller: navigationController) {
                self.navigationController = navigationController
                completion()
            }
        }
    }

    public func dismiss(until controller: UIViewController?, completion: @escaping () -> ()) {
        if let controller = controller {
            return navigationController.pop(to: controller, animated: animated, completion: completion)
        } else {
            return navigationController.pop(animated: animated, completion: completion)
        }
    }
}

fileprivate extension UINavigationController {
    func pop(to viewController: UIViewController, animated: Bool, completion: @escaping () -> ()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion()
        }

        popToViewController(viewController, animated: animated)

        CATransaction.commit()
    }

    func pop(animated: Bool, completion: @escaping () -> ()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion()
        }

        popViewController(animated: animated)

        CATransaction.commit()
    }

    func push(viewController: UIViewController, animated: Bool, completion: @escaping () -> ()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion()
        }

        pushViewController(viewController, animated: animated)

        CATransaction.commit()
    }
}

#endif