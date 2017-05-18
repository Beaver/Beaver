import Beaver

public struct ActionMock: Action {
    public typealias StateType = StateMock

    public var name: String
    
    public init(name: String = "ActionMock") {
        self.name = name
    }

    public static func ==(lhs: ActionMock, rhs: ActionMock) -> Bool {
        return lhs.name == rhs.name
    }
}
