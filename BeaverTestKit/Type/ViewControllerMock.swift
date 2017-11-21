import Beaver

public final class ViewControllerStub<StateType: State, ParentStateType: State, AUIActionType: Action>: ViewController<StateType, ParentStateType, AUIActionType> {
    public private(set) var stateDidUpdateCallCount = 0

    public private(set) var source: ActionEnvelop?

    public private(set) var oldState: StateType?

    public private(set) var newState: StateType?

    public override func stateDidUpdate(oldState: StateType?,
                                        newState: StateType,
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
    }
}
