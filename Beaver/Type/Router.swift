/// A type representing a successful route emission
public protocol RouteSuccess {
}

/// A type representing a failed route emission
public protocol RouteError: Error {
}

/// A type representing a route result
public enum RouteResult<RouteSuccessType:RouteSuccess, RouteErrorType:RouteError> {
    case success(RouteSuccessType)
    case failure(RouteErrorType)
}

/// A type representing a route
///
/// ## Notes: ##
/// 1. It is the only public interfaces of the modules.
/// 2. It represents a path into the module.
/// 3. It carries data to parametrize your module when needed.
public protocol Route {
    associatedtype RouteSuccessType: RouteSuccess

    associatedtype RouteErrorType: RouteError
}

/// Responsible to emit the modules routes and dispatch its data to the store
public struct Router<RouteType:Route> {
    public typealias RouteResultType = RouteResult<RouteType.RouteSuccessType, RouteType.RouteErrorType>

    public typealias Completion = (_ result: RouteResultType) -> ()

    /// Emits a route and call the completion when done.
    ///
    /// - Parameters:
    ///    - route: a route to emit
    ///    - completion: a completion handler called when done emitting
    public typealias Emitter = (_ route: RouteType,
                                _ file: String,
                                _ function: String,
                                _ line: Int,
                                _ completion: @escaping Completion) -> ()

    public let emit: Emitter

    public init(emit: @escaping Emitter) {
        self.emit = emit
    }
}

/// A type representing an object able to handle routes
public protocol Routing {
    associatedtype ActionType: Action

    /// Handles a route
    ///
    /// - Parameters:
    ///    - route: a route to emit
    ///    - completion: a completion handler called when done emitting
    func handle(route: ActionType.RouteType,
                file: String,
                function: String,
                line: Int,
                completion: @escaping Router<ActionType.RouteType>.Completion)
}

extension Routing {
    /// Default implementation of the router
    public var router: Router<ActionType.RouteType> {
        return Router(emit: {
            self.handle(route: $0, file: $1, function: $2, line: $3, completion: $4)
        })
    }
}

extension Routing where Self: Presenting, Self: Reducing {
    public func handle(route: ActionType.RouteType,
                       file: String = #file,
                       function: String = #function,
                       line: Int = #line,
                       completion: @escaping Router<ActionType.RouteType>.Completion) {
        dispatch(ActionType.mapRouteToAction(from: route),
                 file: file,
                 function: function,
                 line: line)
    }
}
