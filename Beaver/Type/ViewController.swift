#if os(iOS)

import UIKit

open class ViewController<AStateType: State, AParentStateType: State>: UIViewController, Subscribing {
    public typealias StateType = AStateType
    public typealias ParentStateType = AParentStateType

    public let store: ChildStore<StateType, ParentStateType>

    // MARK: - Init
    
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(store: ChildStore<StateType, ParentStateType>) {
        self.store = store

        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - Lifecycle

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        subscribe(to: store)
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        unsubscribe(from: store)
    }

    deinit {
#if DEBUG
        print("[\(self)] --- DEINIT ---")
#endif
    }

    /// Method called when a state update has occurred
    open func stateDidUpdate(oldState: StateType?,
                             newState: StateType,
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
    open func dispatch(action: Action,
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
