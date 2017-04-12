import Beaver

public final class ViewControllerStub<ActionType:Action>: ViewController<ActionType> {
    public private(set) var stateDidUpdateCallCount = 0

    public private(set) var source: ActionEnvelop<ActionType>?

    public private(set) var oldState: Store<ActionType>.StateType?

    public private(set) var newState: Store<ActionType>.StateType?

    public private(set) var action: CoreAction<ActionType>?

    public override func stateDidUpdate(oldState: Store<ActionType>.StateType?,
                                        newState: Store<ActionType>.StateType,
                                        completion: @escaping () -> ()) {
        self.oldState = oldState
        self.newState = newState
        stateDidUpdateCallCount += 1
        completion()
    }

    public func clear() {
        stateDidUpdateCallCount = 0
        source = nil
        oldState = nil
        newState = nil
        action = nil
    }
}
