/// Type representing a
public protocol Context {
    func present(stage: UIViewController, completion: () -> ())

    func dismiss(until stage: UIViewController?, completion: () -> ())
}

extension Context {
    public func dismiss(completion: () -> ()) {
        dismiss(until: nil, completion: completion)
    }
}
