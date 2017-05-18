import Beaver

public final class MiddlewareMock<StateType: State> {
    public private(set) var callCount = 0

    public private(set) var actions: [ActionEnvelop?] = []

    public private(set) var stateUpdates: [(oldState: StateType?, newState: StateType)?] = []

    public var name: String = "MiddlewareMock"
    
    public init() {
        // Do nothing
    }

    public var base: Store<StateType>.Middleware {
        return Store<StateType>.Middleware(name: name) { action, stateUpdate in
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
