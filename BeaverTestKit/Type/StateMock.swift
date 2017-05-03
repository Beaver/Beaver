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
