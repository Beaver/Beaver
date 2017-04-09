import Beaver

public struct SuccessStateMock: SuccessState {
    public var name: String = "SuccessStateMock"

    public static func ==(lhs: SuccessStateMock, rhs: SuccessStateMock) -> Bool {
        return lhs.name == rhs.name
    }
}

public struct FailureStateMock: FailureState {
    public var name: String = "FailureStateMock"

    public var description: String {
        return name
    }

    public static func ==(lhs: FailureStateMock, rhs: FailureStateMock) -> Bool {
        return lhs.name == rhs.name
    }
}