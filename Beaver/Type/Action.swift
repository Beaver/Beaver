/// A type representing a user action
public protocol Action: Equatable {
    /// Type of the expected state update after the action has been triggered
    associatedtype SuccessStateType: SuccessState

    /// Type of the failure state update after the action has been triggered
    associatedtype FailureStateType: FailureState
}

/// Type encapsulating an action and adding extra information
public struct ActionEnvelop<ActionType:Action> {
    public let action: ActionType

    /// Emitter name
    public let emitter: String

    /// File, Function and Line which produced the action
    public typealias DebugInfo = (file: String, function: String, line: Int)

    public let debugInfo: DebugInfo

    public init(emitter: String,
                action: ActionType,
                file: String = #file,
                function: String = #function,
                line: Int = #line) {
        self.emitter = emitter
        self.action = action
        self.debugInfo = (file: file, function: function, line: line)
    }
}

extension ActionEnvelop: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "ActionEnvelop\n" +
                "    Emitter:      \(emitter)\n" +
                "    Action:       \(action)\n" +
                "    Produced by:\n" +
                "        File:     \(debugInfo.file)\n" +
                "        Function: \(debugInfo.function)\n" +
                "        Line:     \(debugInfo.line)"
    }
}
