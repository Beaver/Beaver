/// A type representing a user action
public protocol Action: Equatable {
    /// Type of the expected state update after the action has been triggered
    associatedtype SuccessStateType: SuccessState

    /// Type of the failure state update after the action has been triggered
    associatedtype FailureStateType: FailureState
}

/// Type containing commonly used actions and business actions
public enum CoreAction<ActionType: Action> {
    case navigation(NavigationAction)
    case lifeCycle(LifeCycleAction)
    case business(ActionType)
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
    public let action: CoreAction<ActionType>

    /// Emitter name
    public let emitter: String

    /// Extra payload
    public let payload: [AnyHashable: Any]?

    /// File, Function and Line which produced the action
    public let debugInfo: (file: String,
                           function: String,
                           line: Int)

    public init(emitter: String,
                action: CoreAction<ActionType>,
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

extension ActionEnvelop {
    /// Determine either the action is a life cycle action or not
    public var isLifeCycleAction: Bool {
        switch action {
        case .lifeCycle:
            return true
        default:
            return false
        }
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
