/// A type representing a user action
public protocol Action {
    /// Type of the expected state update after the action has been triggered
    associatedtype SuccessStateType: SuccessState

    /// Type of the failure state update after the action has been triggered
    associatedtype FailureStateType: FailureState

    /// Used by the base stage which needs to be able to build a core action
    /// scoped with its ActionType
    static func create(coreAction: CoreAction) -> Self
}

public enum CoreAction{
    case navigation(NavigationAction)
    case lifeCycle(LifeCycleAction)
}

public enum LifeCycleAction {
    case didLoadView
    case didShowView
}

public enum NavigationAction {
    case didTapOnBackButton
    case didTapOnCloseButton
}

/// Type encapsulated an action and adding extra information
public struct ActionEnvelop<ActionType: Action> {
    public let action: ActionType

    /// Emitter name
    public let emitter: String

    /// Extra payload
    public let payload: [AnyHashable: Any]?

    /// Emitting file
    public let file: String

    /// Emitting function
    public let function: String

    /// Emitting line
    public let line: Int

    public init(emitter: String,
                action: ActionType,
                payload: [AnyHashable: Any]? = nil,
                file: String = #file,
                function: String = #function,
                line: Int = #line) {
        self.emitter = emitter
        self.action = action
        self.payload = payload
        self.file = file
        self.function = function
        self.line = line
    }
}

extension ActionEnvelop: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "ActionEnvelop\n" +
                "    Emitter:  \(emitter)\n" +
                "    Action:   \(action)\n" +
                "    Payload:  \(String(describing: payload))\n" +
                "    File:     \(file)\n" +
                "    Function: \(function)\n" +
                "    Line:     \(line)"
    }
}
