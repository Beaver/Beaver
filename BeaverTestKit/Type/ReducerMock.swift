import Beaver

public final class ReducerMock<ActionType: Action> {
    public private(set) var callCount = 0

    public private(set) var envelop: ActionEnvelop<ActionType>?

    public private(set) var state: Store<ActionType>.StateType?

    public var newStateStub: Store<ActionType>.StateType
    
    public var newCompletedStateStub: Store<ActionType>.StateType

    public init(newStateStub: Store<ActionType>.StateType,
                newCompletedStateStub: Store<ActionType>.StateType) {
        self.newStateStub = newStateStub
        self.newCompletedStateStub = newCompletedStateStub
    }
    
    public init(newStateStub: Store<ActionType>.StateType) {
        self.newStateStub = newStateStub
        self.newCompletedStateStub = newStateStub
    }

    public var base: Store<ActionType>.Reducer {
        return { envelop, state, completion in
            self.envelop = envelop
            self.state = state
            self.callCount += 1
            DispatchQueue.main.async {
                completion(self.newCompletedStateStub)
            }
            return self.newStateStub
        }
    }

    public func clear() {
        callCount = 0
        envelop = nil
        state = nil
    }
}
