import Beaver

public final class ContextMock: Context {
    public private(set) var presentedViews = [UIViewController]()

    public private(set) var dismissedUntilViews = [UIViewController?]()

    public func present(view: UIViewController, completion: () -> ()) {
        presentedViews.append(view)
        completion()
    }

    public func dismiss(until view: UIViewController?, completion: () -> ()) {
        dismissedUntilViews.append(view)
        completion()
    }
}