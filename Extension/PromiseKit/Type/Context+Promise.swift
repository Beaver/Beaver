import UIKit
import Beaver

extension Context {
    public func present(controller: UIViewController) -> SafePromise<()> {
        return SafePromise { fulfill in
            present(controller: controller, completion: fulfill)
        }
    }

    public func dismiss(until controller: UIViewController? = nil) -> SafePromise<()> {
        return SafePromise { fulfill in
            dismiss(until: controller, completion: fulfill)
        }
    }
}