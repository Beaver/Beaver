import Beaver
import PromiseKit

public protocol PMKSubscribing: Subscribing {
    func stateDidUpdate(source: ActionEnvelop<ActionType>?,
                        oldState: Store<ActionType>.StateType?,
                        newState: Store<ActionType>.StateType) -> Promise<()>
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
