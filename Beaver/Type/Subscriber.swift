extension Store {
    /// An object observing state updates
    public struct Subscriber {
        /// Called when the store's state changed
        ///
        /// - Parameters:
        ///     - source: action that generated the state update
        ///     - oldState: previous state
        ///     - newState: generated state
        ///     - completion: a completion handler called when done
        public typealias StateDidUpdate = (_ source: ActionEnvelop<ActionType>?,
                                           _ oldState: StateType?,
                                           _ newState: StateType,
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

    func stateDidUpdate(source: ActionEnvelop<ActionType>?,
                        oldState: Store<ActionType>.StateType?,
                        newState: Store<ActionType>.StateType,
                        completion: @escaping () -> ())

    func didStartStateUpdate(source: ActionEnvelop<ActionType>?,
                             oldState: Store<ActionType>.StateType?,
                             newState: Store<ActionType>.StateType)

    func didFinishStateUpdate(source: ActionEnvelop<ActionType>?,
                              oldState: Store<ActionType>.StateType?,
                              newState: Store<ActionType>.StateType)

}

extension Subscribing {
    public var subscriptionName: String {
        return String(describing: type(of: self))
    }

    var isSubscriptionWeak: Bool {
        return true
    }
    
    public typealias StateUpdateEvent = (_ source: ActionEnvelop<ActionType>?,
                                         _ oldState: Store<ActionType>.StateType?,
                                         _ newState: Store<ActionType>.StateType) -> ()

    // Default implementation
    public func didStartStateUpdate(source: ActionEnvelop<ActionType>?,
                                    oldState: Store<ActionType>.StateType?,
                                    newState: Store<ActionType>.StateType) {
        // Do nothing
    }

    // Default implementation
    public func didFinishStateUpdate(source: ActionEnvelop<ActionType>?,
                                     oldState: Store<ActionType>.StateType?,
                                     newState: Store<ActionType>.StateType) {
        // Do nothing
    }

    /// Subscribes to a store.
    public func subscribe(to store: Store<ActionType>) {
        if isSubscriptionWeak {
            store.subscribe(name: subscriptionName) { [weak self] source, oldState, newState, completion in
                self?.didStartStateUpdate(source: source, oldState: oldState, newState: newState)
                self?.stateDidUpdate(source: source, oldState: oldState, newState: newState) { [weak self] in
                    self?.didFinishStateUpdate(source: source, oldState: oldState, newState: newState)
                }
            }
        } else {
            store.subscribe(name: subscriptionName) { source, oldState, newState, completion in
                self.didStartStateUpdate(source: source, oldState: oldState, newState: newState)
                self.stateDidUpdate(source: source, oldState: oldState, newState: newState) {
                    self.didFinishStateUpdate(source: source, oldState: oldState, newState: newState)
                }
            }
        }
    }
}

extension Subscribing where Self: UIViewController {
    public var isSubscriptionWeak: Bool {
        return false
    }
}
