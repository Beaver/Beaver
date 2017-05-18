import Beaver

public struct StateMock: State {
    public var name: String

    public init(name: String = "SuccessStateMock") {
        self.name = name
    }

    public static func ==(lhs: StateMock, rhs: StateMock) -> Bool {
        return lhs.name == rhs.name
    }
}

public struct AppStateMock: State {
    public var childState: StateMock?
    
    public init(childState: StateMock? = StateMock()) {
        self.childState = childState
    }
    
    public static func ==(lhs: AppStateMock, rhs: AppStateMock) -> Bool {
        return lhs.childState == rhs.childState
    }
}
