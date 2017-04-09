import Beaver

public final class ContextMock: Context {
    public private(set) var presentedViews = [UIViewController]()

    public private(set) var dismissedUntilViews = [UIViewController?]()

    public func present(controller: UIViewController, completion: @escaping () -> ()) {
        presentedViews.append(controller)
        completion()
    }

    public func dismiss(until controller: UIViewController?, completion: @escaping () -> ()) {
        dismissedUntilViews.append(controller)
        completion()
    }
}