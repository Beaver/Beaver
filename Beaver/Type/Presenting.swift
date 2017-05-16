/// Type responsible for the views presentation
public protocol Presenting: Subscribing {
    var context: Context { get }

    weak var weakStore: Store<ActionType>? { get set }

    var middlewares: [Store<ActionType>.Middleware] { get }

    var initialState: Store<ActionType>.StateType { get }
}

extension Presenting {
    /// Default implementation
    public var middlewares: [Store<ActionType>.Middleware] {
        return []
    }

    /// Dispatches an action to the store and automatically sets the emitter to the scene's subscription name
    public func dispatch(_ action: ActionType,
                         on store: Store<ActionType>? = nil,
                         file: String = #file,
                         function: String = #function,
                         line: Int = #line) {
        if let store = store ?? self.weakStore {
            store.dispatch(ActionEnvelop(emitter: subscriptionName,
                                         action: action,
                                         recipients: .allExcludingEmitter,
                                         file: file,
                                         function: function,
                                         line: line))
        } else {
#if DEBUG
            print("The store has been removed before dispatching, which means all your views has been removed as well")
#endif
        }
    }
}

extension Presenting where Self: Subscribing, Self: Reducing {
    /// Creates a new store and subscribes before returning
    public func createStore() -> Store<ActionType> {
        return createStore(initialState: initialState,
                           middleWares: middlewares)
    }

    /// Creates a store if not done yet and returns it
    public var store: Store<ActionType> {
        if let store = self.weakStore {
            return store
        }
        let newStore = createStore()
        weakStore = newStore
        return newStore
    }

    /// Dispatches an action to the store and automatically sets the emitter to the scene's subscription name
    public func dispatch(_ action: ActionType,
                         on store: Store<ActionType>? = nil,
                         file: String = #file,
                         function: String = #function,
                         line: Int = #line) {
        dispatch(action,
                 on: store ?? self.store,
                 file: file,
                 function: function,
                 line: line)
    }
}
