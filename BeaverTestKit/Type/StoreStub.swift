import Beaver

public final class StoreStub<ActionType:Action> {
    public var initialStateStub: Store<ActionType>.StateType

    public var reducerMock: ReducerMock<ActionType>

    public init(initialStateStub: Store<ActionType>.StateType,
                reducerMock: ReducerMock<ActionType>) {
        self.initialStateStub = initialStateStub
        self.reducerMock = reducerMock
    }

    public var base: Store<ActionType> {
        return Store<ActionType>(initialState: initialStateStub, reducer: reducerMock.base)
    }
}
