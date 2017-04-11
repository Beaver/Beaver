import Beaver
import PromiseKit

public protocol PMKReducing: Reducing {
    func handle(envelop: ActionEnvelop<ActionType>, state: Store<ActionType>.StateType) -> Promise<Store<ActionType>.StateType>
}

extension PMKReducing {
    public func handle(envelop: ActionEnvelop<ActionType>,
                       state: Store<ActionType>.StateType,
                       completion: @escaping (Store<ActionType>.StateType) -> ()) {
        handle(envelop: envelop, state: state).then { newState in
            completion(newState)
        }
    }
}
