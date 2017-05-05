#if os(iOS)

import UIKit

open class ViewController<AActionType: Action>: UIViewController, Subscribing {
    public typealias ActionType = AActionType
    
    public let store: Store<ActionType>

    // MARK: - Init
    
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(store: Store<ActionType>) {
        self.store = store

        super.init(nibName: nil, bundle: nil)

        subscribe(to: self.store)
    }

    // MARK: - Lifecycle
    
    deinit {
        store.unsubscribe(subscriptionName)

#if DEBUG
        print("[\(self)] --- DEINIT ---")
#endif
    }

    /// Method called when a state update has occurred
    open func stateDidUpdate(oldState: Store<ActionType>.StateType?,
                             newState: Store<ActionType>.StateType,
                             completion: @escaping () -> ()) {
        fatalError("stateDidUpdate(source:oldState:newState:completion:) has not been implemented")
    }

    // MARK: Dispatch

    /// Dispatches an action to the store
    ///
    /// - Parameters:
    ///    - action: the action to be dispatched
    ///    - silent: if true, the `didStartLoading(silent:)` and `didFinishLoading(state:silent:)` will be called with
    ///              the parameter `silent` set to `true`
    ///    - debugInfo: a tuple containing the file, function and line from where the action has been dispatched
    open func dispatch(action: ActionType,
                       file: String = #file,
                       function: String = #function,
                       line: Int = #line) {
        store.dispatch(ActionEnvelop(
                emitter: subscriptionName,
                action: action,
                file: file,
                function: function,
                line: line))
    }
}

#endif
