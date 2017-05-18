import Beaver

public final class StoreStub<StateType: State> {
    public var initialStateStub: StateType

    public var reducerMock: ReducerMock<StateType>

    public init(initialStateStub: StateType,
                reducerMock: ReducerMock<StateType>) {
        self.initialStateStub = initialStateStub
        self.reducerMock = reducerMock
    }

    public var base: Store<StateType> {
        return Store<StateType>(initialState: initialStateStub, reducer: reducerMock.base)
    }
}
