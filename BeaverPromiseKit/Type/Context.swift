import UIKit
import Beaver
import PromiseKit

extension Context {
    public func present(controller: UIViewController) -> Promise<()> {
        return Promise { fulfill, _ in
            present(controller: controller, completion: fulfill)
        }
    }

    public func dismiss(until controller: UIViewController? = nil) -> Promise<()> {
        return Promise { fulfill, _ in
            dismiss(until: controller, completion: fulfill)
        }
    }
}
