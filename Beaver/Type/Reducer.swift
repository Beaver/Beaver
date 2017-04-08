extension Store {
    /// Type responsible of generating a state for a given action and the current state
    ///
    /// - Parameters:
    ///     - envelop: the action provoking the state update
    ///     - state: the current state
    ///     - completion: completion handler called when the new state is ready
    public typealias Reducer = (_ envelop: ActionEnvelop<ActionType>,
                                _ state: StateType,
                                _ completion: (StateType) -> ()) -> ()
}

/// Responsible of generating a state for a given action and the current state
public protocol Reducing {
    associatedtype ActionType: Action

    /// Generates a state for a given action and the current state
    ///
    /// - Parameters:
    ///     - envelop: the action provoking the state update
    ///     - state: the current state
    ///     - completion: completion handler called when the new state is ready
    func handle(envelop: ActionEnvelop<ActionType>,
                state: Store<ActionType>.StateType,
                completion: (Store<ActionType>.StateType) -> ())
}

extension Reducing {
    /// Default implementation of the reducer
    public var reducer: Store<ActionType>.Reducer {
        return { envelop, state, completion in
            return self.handle(envelop: envelop, state: state, completion: completion)
        }
    }
}