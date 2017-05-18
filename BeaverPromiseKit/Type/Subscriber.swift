import Beaver
import PromiseKit

public protocol PMKSubscribing: Subscribing {
    func stateDidUpdate(source: ActionEnvelop?,
                        oldState: StateType?,
                        newState: StateType) -> Promise<()>
}

extension PMKSubscribing {
    public func stateDidUpdate(source: ActionEnvelop?,
                               oldState: StateType?,
                               newState: StateType,
                               completion: @escaping () -> ()) {
        _ = stateDidUpdate(source: source,
                           oldState: oldState,
                           newState: newState).then(execute: completion)
    }
}
