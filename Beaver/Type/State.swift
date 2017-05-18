/// A type representing a state
///
/// ## Notes: ##
/// 1. It represents the data showed by your views.
/// 2. It should only contain literal types like `String`, `Int` or `Bool`.
/// 3. It should not contain any business logic since it is the result of the reducer's business logic
public protocol State: Equatable {
}
