extension Store {
    /// Type responsible of generating a state for a given action and the current state
    ///
    /// - Parameters:
    ///     - envelop: the action provoking the state update
    ///     - state: the current state
    ///     - completion: completion handler called if asynchronous work has began and need to be completed
    /// - Returns: the new state
    public typealias Reducer = (_ envelop: ActionEnvelop,
                                _ state: StateType,
                                _ completion: @escaping (StateType) -> ()) -> StateType
}

/// Responsible of generating a state for a given action and the current state
public protocol Reducing {
    associatedtype StateType: State

    /// Generates a state for a given action and the current state
    ///
    /// - Parameters:
    ///     - envelop: the action provoking the state update
    ///     - state: the current state
    ///     - completion: completion handler called if asynchronous work has began and need to be completed
    /// - Returns: the new state
    func handle(envelop: ActionEnvelop,
                state: StateType,
                completion: @escaping (StateType) -> ()) -> StateType
}

extension Reducing {
    /// Default implementation of the reducer
    public var reducer: Store<StateType>.Reducer {
        return { envelop, state, completion in
            return self.handle(envelop: envelop, state: state, completion: completion)
        }
    }

    /// Creates a new store
    public func createStore(initialState: StateType,
                            middleWares: [Store<StateType>.Middleware]) -> Store<StateType> {
        return Store<StateType>(initialState: initialState,
                                middlewares: middleWares,
                                reducer: reducer)
    }
}

extension Reducing where Self: Subscribing {
    /// Creates a new store and subscribes before returning
    public func createStore(initialState: StateType,
                            middleWares: [Store<StateType>.Middleware]) -> Store<StateType> {
        let store = Store<StateType>(initialState: initialState,
                                      middlewares: middleWares,
                                     reducer: reducer)
        store.subscribe(name: subscriptionName,
                        stateDidUpdate: stateDidUpdate)
        return store
    }
}