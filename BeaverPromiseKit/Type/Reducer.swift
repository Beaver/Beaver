import Beaver
import PromiseKit

public protocol PMKReducing: Reducing {
    func handle(envelop: ActionEnvelop, state: StateType) -> Promise<StateType>
}

extension PMKReducing {
    public func handle(envelop: ActionEnvelop,
                       state: StateType,
                       completion: @escaping (StateType) -> ()) {
        _ = handle(envelop: envelop, state: state).then { newState in
            completion(newState)
        }
    }
}
