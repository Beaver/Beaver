import Beaver

public final class MiddlewareMock<ActionType: Action> {
    public private(set) var actCallCount = 0

    public private(set) var actions: [ActionEnvelop<ActionType>?] = []

    public private(set) var stateUpdates: [(oldState: Store<ActionType>.StateType?,
                                     newState: Store<ActionType>.StateType)?] = []

    public var name: String = "ActorMock"
    
    public init() {
        // Do nothing
    }

    public var base: Store<ActionType>.Middleware {
        return Store<ActionType>.Middleware(name: name) { action, stateUpdate in
            self.actions.append(action)
            self.stateUpdates.append(stateUpdate)
            self.actCallCount += 1
        }
    }
}
