/// A type representing a user action
public protocol Action: Equatable {
    /// Type of the expected state update after the action has been triggered
    associatedtype SuccessStateType: SuccessState

    /// Type of the failure state update after the action has been triggered
    associatedtype FailureStateType: FailureState
    
    /// Type of the pending state update after an asynchronous action as been triggered
    associatedtype PendingStateType: PendingState

    /// Type of the route
    associatedtype RouteType: Route

    static func createRouteAction(with route: RouteType) -> Self
}

/// Type encapsulating an action and adding extra information
public struct ActionEnvelop<ActionType:Action> {
    public enum DestScope {
        case emitter
        case all
        case allExcludingEmitter
        case authorized(to: Set<String>)
    }

    public let action: ActionType

    /// Emitter name
    public let emitter: String

    /// File, Function and Line which produced the action
    public typealias DebugInfo = (file: String, function: String, line: Int)

    /// Debug info used for logging
    public let debugInfo: DebugInfo

    /// Scope defining which subscribers to send the envelop to
    public let destScope: DestScope

    public init(emitter: String,
                action: ActionType,
                destScope: DestScope = .all,
                file: String = #file,
                function: String = #function,
                line: Int = #line) {
        self.emitter = emitter
        self.action = action
        self.destScope = destScope
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
