import Beaver

public struct SuccessStateMock: SuccessState {
    public var name: String

    public init(name: String = "SuccessStateMock") {
        self.name = name
    }

    public static func ==(lhs: SuccessStateMock, rhs: SuccessStateMock) -> Bool {
        return lhs.name == rhs.name
    }
}

public struct FailureStateMock: FailureState {
    public var name: String

    public init(name: String = "FailureStateMock") {
        self.name = name
    }
    
    public var description: String {
        return name
    }

    public static func ==(lhs: FailureStateMock, rhs: FailureStateMock) -> Bool {
        return lhs.name == rhs.name
    }
}

public struct PendingStateMock: PendingState {
    public var name: String

    public init(name: String = "PendingStateMock") {
        self.name = name
    }

    public static func ==(lhs: PendingStateMock, rhs: PendingStateMock) -> Bool {
        return lhs.name == rhs.name
    }
}

public typealias StateMock = State<SuccessStateMock, FailureStateMock, PendingStateMock>
