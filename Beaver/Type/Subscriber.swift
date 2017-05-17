extension Store {
    /// An object observing state updates
    public struct Subscriber {
        /// Called when the store's state changed
        ///
        /// - Parameters:
        ///     - oldState: previous state
        ///     - newState: generated state
        ///     - completion: a completion handler called when done
        public typealias StateDidUpdate = (_ oldState: StateType?,
                                           _ newState: StateType,
                                           _ file: String,
                                           _ function: String,
                                           _ line: Int,
                                           _ completion: @escaping () -> ()) -> ()

        public let name: String

        public let stateDidUpdate: StateDidUpdate

        public init(name: String,
                    stateDidUpdate: @escaping StateDidUpdate) {
            self.name = name
            self.stateDidUpdate = stateDidUpdate
        }
    }
}

// MARK: - Equatable

extension Store.Subscriber: Equatable {
    public static func ==(lhs: Store<ActionType>.Subscriber, rhs: Store<ActionType>.Subscriber) -> Bool {
        return lhs.name == rhs.name
    }
}

// MARK: - Hashable

extension Store.Subscriber: Hashable {
    public var hashValue: Int {
        return name.hashValue
    }
}

// MARK: - Description

extension Store.Subscriber: CustomDebugStringConvertible {
    public var debugDescription: String {
        return name
    }
}

/// A type responsible for handling state updates
public protocol Subscribing: class {
    associatedtype ActionType: Action

    /// Name automatically given to the store when subscribing
    var subscriptionName: String { get }

    /// Should store be able to retain an instance of the subscribing class or not
    var isSubscriptionWeak: Bool { get }

    func stateDidUpdate(oldState: Store<ActionType>.StateType?,
                        newState: Store<ActionType>.StateType,
                        file: String,
                        function: String,
                        line: Int,
                        completion: @escaping () -> ())
}

extension Subscribing {
    public var subscriptionName: String {
        return String(describing: type(of: self))
    }

    public var isSubscriptionWeak: Bool {
        return true
    }
    
    public typealias StateUpdateEvent = (_ oldState: Store<ActionType>.StateType?,
                                         _ newState: Store<ActionType>.StateType) -> ()

    /// Subscribes to a store.
    public func subscribe(to store: Store<ActionType>) {
        if isSubscriptionWeak {
            // Copy subscription name outside of self
            let subscriptionName = self.subscriptionName

            store.subscribe(name: subscriptionName) { [weak self] oldState, newState, file, function, line, completion in
                if let weakSelf = self {
                    weakSelf.stateDidUpdate(oldState: oldState,
                                            newState: newState,
                                            file: file,
                                            function: function,
                                            line: line,
                                            completion: completion)
                } else {
                    store.unsubscribe(subscriptionName)
                }
            }
        } else {
            store.subscribe(name: subscriptionName) { oldState, newState, file, function, line, completion in
                self.stateDidUpdate(oldState: oldState,
                                    newState: newState,
                                    file: file,
                                    function: function,
                                    line: line,
                                    completion: completion)
            }
        }
    }
}

#if os(iOS)
extension Subscribing where Self: UIViewController {
    public var isSubscriptionWeak: Bool {
        return false
    }
}
#endif
