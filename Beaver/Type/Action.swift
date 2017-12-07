/// A type representing a user action
public protocol Action {
}

/// Type encapsulating an action and adding extra information
public struct ActionEnvelop {
    public enum Recipients {
        case emitter
        case all
        case allExcludingEmitter
        case authorized(to: Set<String>)
    }

    public var action: Action

    /// Emitter name
    public let emitter: String

    /// File, Function and Line which produced the action
    public typealias DebugInfo = (file: String, function: String, line: Int)

    /// Debug info used for logging
    public let debugInfo: DebugInfo

    /// Scope defining which subscribers to send the envelop to
    public let recipients: Recipients

    public init(emitter: String,
                action: Action,
                recipients: Recipients = .all,
                file: String = #file,
                function: String = #function,
                line: Int = #line) {
        self.emitter = emitter
        self.action = action
        self.recipients = recipients
        self.debugInfo = (file: file, function: function, line: line)
    }

    public func update(action: Action) -> ActionEnvelop {
        var envelop = self
        envelop.action = action
        return envelop
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

public enum ExhaustiveAction<RoutingAction: Action, UIAction: Action> {
    case routing(RoutingAction)
    case ui(UIAction)
    
    public init(_ action: Action) {
        if let action = action as? RoutingAction {
            self = .routing(action)
        } else if let action = action as? UIAction {
            self = .ui(action)
        } else {
            fatalError("'action' expected to be either of type \(RoutingAction.self) or \(UIAction.self), but was \(action.self).")
        }
    }
}

