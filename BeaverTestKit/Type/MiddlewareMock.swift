import Beaver

public final class MiddlewareMock<ActionType: Action> {
    public private(set) var callCount = 0

    public private(set) var actions: [ActionEnvelop<ActionType>?] = []

    public private(set) var stateUpdates: [(oldState: Store<ActionType>.StateType?,
                                     newState: Store<ActionType>.StateType)?] = []

    public var name: String = "MiddlewareMock"
    
    public init() {
        // Do nothing
    }

    public var base: Store<ActionType>.Middleware {
        return Store<ActionType>.Middleware(name: name) { action, stateUpdate in
            self.actions.append(action)
            self.stateUpdates.append(stateUpdate)
            self.callCount += 1
        }
    }

    public func clear() {
        callCount = 0
        actions = []
        stateUpdates = []
    }
}
