/// A type representing a user action
public protocol Action: Equatable {
    associatedtype StateType: State

    /// Type of the route
    associatedtype RouteType: Route

    static func mapRouteToAction(from route: RouteType) -> Self
}

/// Type encapsulating an action and adding extra information
public struct ActionEnvelop<ActionType:Action> {
    public enum Recipients {
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
    public let recipients: Recipients

    public init(emitter: String,
                action: ActionType,
                recipients: Recipients = .all,
                file: String = #file,
                function: String = #function,
                line: Int = #line) {
        self.emitter = emitter
        self.action = action
        self.recipients = recipients
        self.debugInfo = (file: file, function: function, line: line)
    }
}

extension ActionEnvelop: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "ActionEnvelop\n" +
                "    Emitter:      \(emitter)\n" +
                "    Recipients:   \(recipients)\n" +
                "    Action:       \(action)\n" +
                "    Produced by:\n" +
                "        File:     \(debugInfo.file)\n" +
                "        Function: \(debugInfo.function)\n" +
                "        Line:     \(debugInfo.line)"
    }
}
