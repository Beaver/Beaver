open class ViewContainer<AActionType: Action>: UIViewController, Subscribing {
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
#if DEBUG
        print("[\(self)] --- DEINIT ---")
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

    /// Method called when a state update has occurred
    open func git sstateDidUpdate(source: ActionEnvelop<ActionType>?,
                             oldState: Store<ActionType>.StateType?,
                             newState: Store<ActionType>.StateType,
                             completion: @escaping () -> ()) {
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
                       silent: Bool = false,
                       debugInfo: ActionEnvelop<ActionType>.DebugInfo = (file: #file, function: #function, line: #line)) {
        didStartLoading(silent: silent)
        store.dispatch(ActionEnvelop(
                emitter: name,
                action: action,
                payload: ["silent": silent],
                debugInfo: debugInfo))
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
