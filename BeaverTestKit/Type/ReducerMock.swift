import Beaver

public final class ReducerMock<StateType: State> {
    public private(set) var callCount = 0

    public private(set) var envelop: ActionEnvelop?

    public private(set) var state: StateType?

    public var newStateStub: StateType
    
    public var newCompletedStateStub: StateType

    public init(newStateStub: StateType,
                newCompletedStateStub: StateType) {
        self.newStateStub = newStateStub
        self.newCompletedStateStub = newCompletedStateStub
    }
    
    public init(newStateStub: StateType) {
        self.newStateStub = newStateStub
        self.newCompletedStateStub = newStateStub
    }

    public var base: Store<StateType>.Reducer {
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
