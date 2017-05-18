/// Type responsible for the views presentation
public protocol Presenting: Subscribing {
    var context: Context { get }

    var store: Store<StateType> { get }
}

extension Presenting {
    /// Dispatches an action to the store and automatically sets the emitter to the scene's subscription name
    public func dispatch(_ action: Action,
                         file: String = #file,
                         function: String = #function,
                         line: Int = #line) {
        store.dispatch(ActionEnvelop(emitter: subscriptionName,
                                     action: action,
                                     recipients: .allExcludingEmitter,
                                     file: file,
                                     function: function,
                                     line: line))
    }
}

extension Presenting where Self: Subscribing, Self: Reducing {
    /// Dispatches an action to the store and automatically sets the emitter to the scene's subscription name
    public func dispatch(_ action: Action,
                         file: String = #file,
                         function: String = #function,
                         line: Int = #line) {
        dispatch(action,
                 file: file,
                 function: function,
                 line: line)
    }
}
