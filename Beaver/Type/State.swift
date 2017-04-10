/// A type representing a successful state update
public protocol SuccessState: Equatable {
}

/// A type representing a failed state update
public protocol FailureState: CustomStringConvertible, Equatable {
}

/// A type representing a state
///
/// ## Notes: ##
/// 1. It represents the data showed by your views.
/// 2. It should only contain literal types like `String`, `Int` or `Bool`.
/// 3. It should not contain any business logic since it is the result of the reducer's business logic
public enum State<SuccessStateType: SuccessState, FailureStateType: FailureState> {
    case success(SuccessStateType)
    case failure(FailureStateType, previous: SuccessStateType)
}

extension State: Equatable {
    public static func ==(lhs: State<SuccessStateType, FailureStateType>, rhs: State<SuccessStateType, FailureStateType>) -> Bool {
        switch (lhs, rhs) {
        case (.success(let left), .success(let right)):
            return left == right
        case (.failure(let leftError, let leftPrevious), .failure(let rightError, let rightPrevious)):
            return leftError == rightError && leftPrevious == rightPrevious
        default:
            return false
        }
    }
}
