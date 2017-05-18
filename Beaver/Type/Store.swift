/// Responsible of dispatching actions and states.
/// It also holds a state, permitting to notify state changes to its subscribers.
///
/// - Parameters:
///     - ActionType: a type defining the action type
///
/// ## Important Notes: ##
/// 1. Subscribers are store in a set, which means they are called with an indefinite order!
/// 2. Subscribers are blocks, which means that the subscriber itself is responsible
///    of telling if its `self` should be retained or not by the store.
///    In main cases, stages need to declare a `weak self` in order to prevent retain cycles, when the scene
///    needs to declare a `strong self`.
/// 3. Subscribers registration is based on their name. Meaning that two subscribers with
///    the same name would override each others
public final class Store<StateType: State> {

    /// Responsible of applying side effects for a given action or a state update
    public struct Middleware {
        public typealias Run = (_ action: ActionEnvelop?,
            _ stateUpdate: (oldState: StateType?, newState: StateType)?) -> Void

        public let name: String

        public let run: Run

        public init(name: String, run: @escaping Run) {
            self.name = name
            self.run = run
        }
    }

    /// Current state
    fileprivate(set) public var state: StateType

    fileprivate func setState(_ newState: StateType, for envelop: ActionEnvelop) {
        if state == newState {
            return
        }

        let oldState = self.state
        self.state = newState

        middleware.run(envelop, (oldState: oldState, newState: newState))

        for subscriber in subscribers.values {
            switch envelop.recipients {
            case .emitter:
                if subscriber.name != envelop.emitter {
                    continue
                }
            case .allExcludingEmitter:
                if subscriber.name == envelop.emitter {
                    continue
                }
            case .authorized(to: let names):
                if !names.contains(subscriber.name) {
                    continue
                }
            default:
                break
            }

            subscriber.stateDidUpdate(oldState, newState) {
                // do nothing
            }
        }
    }

    fileprivate let reducer: Reducer

    fileprivate(set) public var subscribers = [String: Subscriber]()

    fileprivate var middleware: Middleware {
        return Middleware.composite(middlewares)
    }

    fileprivate var cancellable = Cancellable()

    /// Registered actors
    public let middlewares: [Middleware]

    /// Store initialization
    ///
    /// - Parameters:
    ///     - initialState: the first current state
    ///     - middlewares: a list of middleWares, responsible of side effects like logging, tracking, ...
    ///     - reducer: the reducer, responsible for new states generation
    public init(initialState: StateType,
                middlewares: [Middleware] = [],
                reducer: @escaping Reducer) {
        self.reducer = reducer
        state = initialState
        self.middlewares = middlewares

        // stateDidSet is not called so we need to dispatch to actors here
        middleware.run(nil, (oldState: nil, newState: initialState))
    }
}

// MARK: - Dispatching

extension Store {
    /// Dispatching interface
    ///
    /// It is retaining a reference on the store
    func dispatch(_ envelop: ActionEnvelop) {
        // Lifecycle actions are not cancellable
        let cancellable = self.newCancellable()

        self.middleware.run(envelop, nil)

        let newState = self.reducer(envelop, self.state) { newState in
            if !cancellable.isCancelled {
                self.setState(newState, for: envelop)
            }
        }

        self.setState(newState, for: envelop)
    }
}

// MARK: - Subscribing

extension Store {
    /// Adds a new subscriber
    public func subscribe(_ subscriber: Subscriber) {
        subscribers[subscriber.name] = subscriber

        // Dispatching the state update permits to avoid infinite recursions when
        // the `stateDidUpdate` method implementation refers the store
        subscriber.stateDidUpdate(nil, self.state) {
            // do nothing
        }
    }

    /// Build and add a new subscriber
    ///
    /// - Parameters:
    ///     - name: the subscriber's name
    ///     - stateDidUpdate: the subscriber state update handler
    public func subscribe(name: String, stateDidUpdate: @escaping Subscriber.StateDidUpdate) {
        subscribe(Subscriber(name: name, stateDidUpdate: stateDidUpdate))
    }

    /// Removes a subscriber
    public func unsubscribe(_ name: String) {
        subscribers.removeValue(forKey: name)
    }
}

// MARK: - Description

extension Store: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "\(self) - subscribers: [\(subscribers.map { $0.value.debugDescription })]"
    }
}

// MARK: - Cancellation

fileprivate extension Store {
    final class Cancellable {
        private(set) var isCancelled: Bool = false

        func cancel() {
            isCancelled = true
        }
    }

    func newCancellable() -> Cancellable {
        cancellable.cancel()
        let actionCancellable = Cancellable()
        cancellable = actionCancellable
        return actionCancellable
    }
}
