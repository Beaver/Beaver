import Beaver
import PromiseKit

extension Router {
    public func emit(_ route: RouteType) -> Promise<RouteResultType> {
        return Promise { fulfill, _ in
            self.emit(route, fulfill)
        }
    }
}

public protocol PMKRouting: Routing {
    func handle(route: RouteType) -> Promise<Router<RouteType>.RouteResultType>
}

extension PMKRouting {
    public func handle(route: RouteType, completion: @escaping Router<RouteType>.Completion) {
        _ = handle(route: route).then { result in
            completion(result)
        }
    }
}
