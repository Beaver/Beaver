/// Type responsible for the views presentation
public protocol Presenting: Subscribing {
    var context: Context { get }

    weak var store: Store<ActionType>? { get }

    var middleWares: [Store<ActionType>.MiddleWare] { get }
}

extension Presenting {
    /// Dispatches an action to the store and automatically sets the emitter to the scene's subscription name
    public func dispatch(_ action: CoreAction<ActionType>,
                         on store: Store<ActionType>? = nil,
                         payload: [AnyHashable: Any]? = nil,
                         debugInfo: ActionEnvelop<ActionType>.DebugInfo = (file: #file, function: #function, line: #line)) {
        if let store = store ?? self.store {
            store.dispatch(ActionEnvelop(emitter: subscriptionName,
                                         action: action,
                                         payload: payload,
                                         debugInfo: debugInfo))
        } else {
#if DEBUG
            print("The store has been removed before dispatching, which means all your views has been removed as well")
#endif
        }
    }
}
