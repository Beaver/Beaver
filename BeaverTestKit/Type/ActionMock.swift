import Beaver

public struct ActionMock: Action {
    public typealias SuccessStateType = SuccessStateMock

    public typealias FailureStateType = FailureStateMock

    public var name: String = "ActionMock"

    public static func ==(lhs: ActionMock, rhs: ActionMock) -> Bool {
        return lhs.name == rhs.name
    }
}