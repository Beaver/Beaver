/// A type representing a successful state update

public protocol SuccessState: Equatable {
}

/// A type representing a failed state update

public protocol FailureState: CustomStringConvertible, Equatable {
}

/// A type representing a pending state

public protocol PendingState: Equatable {
}

/// A type representing a state
///
/// ## Notes: ##
/// 1. It represents the data showed by your views.
/// 2. It should only contain literal types like `String`, `Int` or `Bool`.
/// 3. It should not contain any business logic since it is the result of the reducer's business logic

public enum State<SuccessStateType:SuccessState,
                 FailureStateType:FailureState,
                 PendingStateType:PendingState> {
    case success(SuccessStateType)
    case failure(error: FailureStateType, last: SuccessStateType)
    case pending(pending: PendingStateType, last: SuccessStateType)
}

extension State {
    public var lastSuccess: SuccessStateType {
        switch self {
        case .success(let state):
            return state
        case .failure(_, let state):
            return state
        case .pending(_, let state):
            return state
        }
    }
}

extension State: Equatable {
    public static func ==(lhs: State<SuccessStateType, FailureStateType, PendingStateType>,
                          rhs: State<SuccessStateType, FailureStateType, PendingStateType>) -> Bool {
        switch (lhs, rhs) {
        case (.success(let left), .success(let right)):
            return left == right
        case (.failure(let leftError), .failure(let rightError)):
            return leftError == rightError
        default:
            return false
        }
    }
}
