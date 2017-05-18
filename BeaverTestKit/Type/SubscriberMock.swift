import Beaver

public final class SubscriberMock<ActionType:Action> {
    public var name: String

    public private(set) var oldState: Store<ActionType>.StateType?

    public private(set) var newState: Store<ActionType>.StateType?

    public private(set) var callCount = 0

    public init(name: String = "ScriptSubscriberMock") {
        self.name = name
    }

    public var base: Store<ActionType>.Subscriber {
        return Store<ActionType>.Subscriber(name: self.name) { oldState, newState, completion in
            self.oldState = oldState
            self.newState = newState
            self.callCount += 1
            completion()
        }
    }

    public func clear() {
        oldState = nil
        newState = nil
        callCount = 0
    }
}
