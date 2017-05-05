#if os(iOS)

public struct WindowContext: Context {
    let window: UIWindow

    let animated: Bool

    public init(window: UIWindow, animated: Bool = true) {
        self.window = window
        self.animated = animated
    }

    public func present(controller: UIViewController, completion: @escaping () -> ()) {
        if window.rootViewController == nil || !animated {
            window.rootViewController = controller
            completion()
        } else {
            window.rootViewController = controller
            if let screenshot = window.rootViewController!.view.snapshotView(afterScreenUpdates: false)  {
                controller.view.addSubview(screenshot)
                UIView.animate(withDuration: 0.125, animations: {
                    screenshot.alpha = 0
                }, completion: { _ in
                    screenshot.removeFromSuperview()
                    completion()
                })
            } else {
                completion()
            }
        }
    }

    public func dismiss(until view: UIViewController?, completion: @escaping () -> ()) {
        window.rootViewController!.dismiss(animated: self.animated, completion: completion)
    }
}

#endif