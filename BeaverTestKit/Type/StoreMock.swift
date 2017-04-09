import Beaver

public final class StoreMock<ActionType:Action> {
    public var initialStateStub: Store<ActionType>.StateType

    public var reducerMock: ReducerMock<ActionType>

    public init(initialStateStub: Store<ActionType>.StateType,
                directorMock: ReducerMock<ActionType>) {
        self.initialStateStub = initialStateStub
        self.reducerMock = directorMock
    }

    public var base: Store<ActionType> {
        return Store<ActionType>(initialState: initialStateStub, reducer: reducerMock.base)
    }
}
