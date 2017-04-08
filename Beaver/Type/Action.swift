/// A type representing a user action
public protocol Action {
    /// Type of the expected state update after the action has been triggered
    associatedtype SuccessStateType: SuccessState

    /// Type of the failure state update after the action has been triggered
    associatedtype FailureStateType: FailureState

    /// Determine either the action is a life cycle action or not
    var isLifeCycle: Bool { get }

    /// Used by the base stage which needs to be able to build a core action
    /// scoped with its ActionType
    static func create(coreAction: CoreAction) -> Self
}

extension Action {
    public var isLifeCycle: Bool {
        return "\(self)".contains("CoreAction.lifeCycle")
    }
}

/// Type containing any commonly used actions
public enum CoreAction {
    case navigation(NavigationAction)
    case lifeCycle(LifeCycleAction)
}

/// Actions dispatched on lifecycle events
public enum LifeCycleAction {
    case didLoadView
    case didShowView
}

/// Actions dispatched on navigation events
public enum NavigationAction {
    case didTapOnBackButton
    case didTapOnCloseButton
}

/// Type encapsulated an action and adding extra information

public struct ActionEnvelop<ActionType:Action> {
    public let action: ActionType

    /// Emitter name
    public let emitter: String

    /// Extra payload
    public let payload: [AnyHashable: Any]?

    /// File, Function and Line which produced the action
    public let debugInfo: (file: String,
                           function: String,
                           line: Int)

    public init(emitter: String,
                action: ActionType,
                payload: [AnyHashable: Any]? = nil,
                file: String = #file,
                function: String = #function,
                line: Int = #line) {
        self.emitter = emitter
        self.action = action
        self.payload = payload
        self.debugInfo = (
                file: file,
                function: function,
                line: line
        )
    }
}

extension ActionEnvelop: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "ActionEnvelop\n" +
                "    Emitter:      \(emitter)\n" +
                "    Action:       \(action)\n" +
                "    Payload:      \(String(describing: payload))\n" +
                "    Produced by:\n" +
                "        File:     \(debugInfo.file)\n" +
                "        Function: \(debugInfo.function)\n" +
                "        Line:     \(debugInfo.line)"
    }
}
