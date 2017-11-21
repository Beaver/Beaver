#if os(iOS)

import UIKit

open class ViewController<AStateType: State, AParentStateType: State, AUIActionType: Action>: UIViewController, Subscribing, ChildStoring {
    public typealias StateType = AStateType
    public typealias ParentStateType = AParentStateType
    public typealias UIActionType = AUIActionType

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

        subscribe()
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        unsubscribe()
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
    open func dispatch(action: UIActionType,
                       file: String = #file,
                       function: String = #function,
                       line: Int = #line) {
        let envelop = ActionEnvelop(
            emitter: subscriptionName,
            action: action,
            recipients: .all,
            file: file,
            function: function,
            line: line
        )
        store.dispatch(envelop)
    }

    // MARK: - State
    
    /// Retrive the state from the store
    public var state: StateType {
        return store.state
    }
}

#endif
