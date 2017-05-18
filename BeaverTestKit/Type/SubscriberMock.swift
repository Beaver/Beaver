import Beaver

public final class SubscriberMock<StateType:State> {
    public var name: String

    public private(set) var oldState: StateType?

    public private(set) var newState: StateType?

    public private(set) var callCount = 0

    public init(name: String = "ScriptSubscriberMock") {
        self.name = name
    }

    public var base: Store<StateType>.Subscriber {
        return Store<StateType>.Subscriber(name: self.name) { oldState, newState, completion in
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
