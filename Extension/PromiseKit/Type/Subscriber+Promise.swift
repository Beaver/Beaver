import Beaver

public protocol PMKSubscribing: Subscribing {
    func stateDidUpdate(source: ActionEnvelop<ActionType>?,
                        oldState: Store<ActionType>.StateType?,
                        newState: Store<ActionType>.StateType) -> SafePromise<()>
}

extension PMKSubscribing {
    public func stateDidUpdate(source: ActionEnvelop<ActionType>?,
                               oldState: Store<ActionType>.StateType?,
                               newState: Store<ActionType>.StateType,
                               completion: @escaping () -> ()) {
        stateDidUpdate(source: source,
                       oldState: oldState,
                       newState: newState).then(execute: completion)
    }
}
