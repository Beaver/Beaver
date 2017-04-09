public protocol Presenting: Subscribing {
    var context: Context { get }
}

extension Presenting {
    /// Dispatches an action to the store and automatically sets the emitter to the scene's subscription nameScript<ActionType>
    public func dispatch(_ action: CoreAction<ActionType>,
                         on store: Store<ActionType>,
                         payload: [AnyHashable: Any]? = nil,
                         debugInfo: ActionEnvelop<ActionType>.DebugInfo = (file: #file, function: #function, line: #line)) {
        store.dispatch(ActionEnvelop(emitter: subscriptionName,
                                     action: action,
                                     payload: payload,
                                     debugInfo: debugInfo))
    }
}
