import Beaver

public final class ReducerMock<ActionType: Action> {
    public private(set) var callCount = 0

    public private(set) var action: ActionEnvelop<ActionType>?

    public private(set) var state: Store<ActionType>.StateType?

    public var newStateStub: Store<ActionType>.StateType

    public init(newStateStub: Store<ActionType>.StateType) {
        self.newStateStub = newStateStub
    }

    public var base: Store<ActionType>.Reducer {
        return { action, state, completion in
            self.action = action
            self.state = state
            self.callCount += 1
            completion(self.newStateStub)
        }
    }
}
