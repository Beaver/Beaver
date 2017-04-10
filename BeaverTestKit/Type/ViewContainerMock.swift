import Beaver

public final class ViewContainerMock<ActionType:Action>: ViewContainer<ActionType> {
    public private(set) var stateDidUpdateCallCount = 0

    public private(set) var source: ActionEnvelop<ActionType>?

    public private(set) var oldState: Store<ActionType>.StateType?

    public private(set) var newState: Store<ActionType>.StateType?

    public private(set) var didStartLoadingCallCount = 0

    public private(set) var didFinishLoadingCallCount = 0

    public private(set) var silent: Bool?

    public override var subscriptionName: String {
        return "ViewContainerMock"
    }

    public override func stateDidUpdate(source: ActionEnvelop<ActionType>?,
                                        oldState: Store<ActionType>.StateType?,
                                        newState: Store<ActionType>.StateType,
                                        completion: @escaping () -> ()) {
        self.source = source
        self.oldState = oldState
        self.newState = newState
        stateDidUpdateCallCount += 1
        completion()
    }

    public override func didStartLoading(silent: Bool) {
        self.silent = silent
        didStartLoadingCallCount += 1
    }

    public override func didFinishLoading(state: Store<ActionType>.StateType, silent: Bool) {
        newState = state
        didFinishLoadingCallCount += 1
    }
}