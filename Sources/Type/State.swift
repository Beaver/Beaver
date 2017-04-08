/// A type representing a successful state update
public protocol SuccessState {
}

/// A type representing a failed state update
public protocol FailureState: CustomStringConvertible {
}

/// A type representing a state
public enum State<SuccessStateType: SuccessState, FailureStateType: FailureState> {
    case success(SuccessStateType)
    case failure(FailureStateType)
}
