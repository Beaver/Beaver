open class ViewContainer<AActionType: Action>: UIViewController, Subscribing {
    public typealias ActionType = AActionType
    
    public let store: Store<ActionType>

    // MARK: init
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(store: Store<ActionType>) {
        self.store = store

        super.init(nibName: nil, bundle: nil)

        subscribe(to: self.store)
    }

    // MARK: lifecycle
    deinit {
#if DEBUG
        print("--- deinit --- \(self)")
#endif
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        dispatch(action: .lifeCycle(.didShowView), silent: true)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true

        dispatch(action: .lifeCycle(.didLoadView))
    }

    open func stateDidUpdate(source: ActionEnvelop<ActionType>?,
                             oldState: Store<ActionType>.StateType?,
                             newState: Store<ActionType>.StateType,
                             completion: () -> ()) {
        fatalError("stateDidUpdate(source:oldState:newState:completion:) has not been implemented")
    }

    /// Registered name for the script
    ///
    /// ## Important Note ##
    /// - Should be overridden if two instances of the same stage are subscribing
    open var name: String {
        return String(describing: type(of: self))
    }

    // MARK: Dispatch

    open func dispatch(action: CoreAction<ActionType>,
                       file: String = #file,
                       function: String = #function,
                       line: Int = #line,
                       silent: Bool = true) {
        didStartLoading(silent: silent)
        store.dispatch(ActionEnvelop(
                emitter: name,
                action: action,
                payload: ["silent": silent],
                file: file,
                function: function,
                line: line))
    }

    // MARK: - Loading

    public func didFinishStateUpdate(source: ActionEnvelop<ActionType>?,
                                     oldState: Store<ActionType>.StateType?,
                                     newState: Store<ActionType>.StateType) {
        let silent: Bool = {
            guard let sourceAction = source,
                  let payload = sourceAction.payload,
                  sourceAction.emitter == subscriptionName else {
                return true
            }

            guard let value = payload["silent"] as? Bool else {
                return true
            }

            return value
        }()

        didFinishLoading(state: newState, silent: silent)
    }

    /// Method called when the stage starts loading.
    open func didStartLoading(silent: Bool) {
    }

    /// Method called when the stage finished loading.
    open func didFinishLoading(state: Store<ActionType>.StateType, silent: Bool) {
    }
}
