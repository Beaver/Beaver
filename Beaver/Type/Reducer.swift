extension Store {
    /// Type responsible of generating a state for a given action and the current state
    ///
    /// - Parameters:
    ///     - envelop: the action provoking the state update
    ///     - state: the current state
    ///     - completion: completion handler called if asynchronous work has began and need to be completed
    /// - Returns: the new state
    public typealias Reducer = (_ envelop: ActionEnvelop<ActionType>,
                                _ state: StateType,
                                _ completion: @escaping (StateType) -> ()) -> StateType
}

/// Responsible of generating a state for a given action and the current state
public protocol Reducing {
    associatedtype ActionType: Action

    /// Generates a state for a given action and the current state
    ///
    /// - Parameters:
    ///     - envelop: the action provoking the state update
    ///     - state: the current state
    ///     - completion: completion handler called if asynchronous work has began and need to be completed
    /// - Returns: the new state
    func handle(envelop: ActionEnvelop<ActionType>,
                state: Store<ActionType>.StateType,
                completion: @escaping (Store<ActionType>.StateType) -> ()) -> Store<ActionType>.StateType
}

extension Reducing {
    /// Default implementation of the reducer
    public var reducer: Store<ActionType>.Reducer {
        return { envelop, state, completion in
            return self.handle(envelop: envelop, state: state, completion: completion)
        }
    }

    /// Creates a new store
    public func createStore(initialState: Store<ActionType>.StateType,
                            middleWares: [Store<ActionType>.Middleware]) -> Store<ActionType> {
        return Store<ActionType>(initialState: initialState,
                                 middlewares: middleWares,
                                 reducer: reducer)
    }
}

extension Reducing where Self: Subscribing {
    /// Creates a new store and subscribes before returning
    public func createStore(initialState: Store<ActionType>.StateType,
                            middleWares: [Store<ActionType>.Middleware]) -> Store<ActionType> {
        let store = Store<ActionType>(initialState: initialState,
                                      middlewares: middleWares,
                                      reducer: reducer)
        store.subscribe(name: subscriptionName,
                        stateDidUpdate: stateDidUpdate)
        return store
    }
}