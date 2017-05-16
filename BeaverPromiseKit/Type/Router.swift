import Beaver
import PromiseKit

extension Router {
    public func emit(_ route: RouteType,
                     file: String = #file,
                     function: String = #function,
                     line: Int = #line) -> Promise<RouteResultType> {
        return Promise { fulfill, _ in
            self.emit(route, file, function, line, fulfill)
        }
    }
}

public protocol PMKRouting: Routing {
    func handle(route: ActionType.RouteType) -> Promise<Router<ActionType.RouteType>.RouteResultType>
}

extension PMKRouting {
    public func handle(route: ActionType.RouteType, completion: @escaping Router<ActionType.RouteType>.Completion) {
        _ = handle(route: route).then { result in
            completion(result)
        }
    }
}
