/// A type representing a successful state update
public protocol SuccessState {
}

/// A type representing a failed state update
public protocol FailureState: CustomStringConvertible {
}

/// A type representing a state
///
/// ## Notes: ##
/// 1. It represents the data showed by your views.
/// 2. It should only contain literal types like `String`, `Int` or `Bool`.
/// 3. It should not contain any business logic since it is the result of the module business logic
public enum State<SuccessStateType: SuccessState, FailureStateType: FailureState> {
    case success(SuccessStateType)
    case failure(error: FailureStateType, previousSuccess: SuccessStateType)
}
