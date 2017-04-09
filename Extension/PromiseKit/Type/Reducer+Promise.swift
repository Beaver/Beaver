import Beaver

protocol PMKReducing: Reducing {
    func handle(envelop: ActionEnvelop<ActionType>, state: Store<ActionType>.StateType) -> SafePromise<Store<ActionType>.StateType>
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
