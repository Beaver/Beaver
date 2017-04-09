import Beaver

extension Router {
    public func emit(_ route: RouteType) -> SafePromise<RouteResultType> {
        return SafePromise { fulfill in
            self.emit(route, fulfill)
        }
    }
}

public protocol PMKRouting: Routing {
    func handle(route: RouteType) -> SafePromise<Router<RouteType>.RouteResultType>
}

extension PMKRouting {
    public func handle(route: RouteType, completion: @escaping Router<RouteType>.Completion) {
        handle(route: route).then { result in
            completion(result)
        }
    }
}
