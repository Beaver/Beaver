/// Type responsible to present and dismiss views
public protocol Context {
    /// Presents a view
    ///
    /// - Parameters:
    ///    - view: the view to present
    ///    - completion: completion handler called when the view is presented (ex: after the animations finished).
    func present(controller: UIViewController, completion: @escaping () -> ())

    /// Dismisses until a view is back on the screen
    ///
    /// - Parameters:
    ///    - until: the view wanted back on screen
    ///    - completion: completion handler called when done (ex: after the animations finished).
    func dismiss(until controller: UIViewController?, completion: @escaping () -> ())
}

extension Context {
    /// Dismisses the current context's view
    ///
    /// - Parameter completion: completion handler called when done (ex: after the animations finished).
    public func dismiss(completion: @escaping () -> ()) {
        dismiss(until: nil, completion: completion)
    }
}
