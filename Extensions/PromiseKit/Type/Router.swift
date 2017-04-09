import Beaver

extension Router {
    public func emit(_ route: RouteType) -> SafePromise<RouteResultType> {
        return SafePromise { fulfill in
            self.emit(route, fulfill)
        }
    }
}

extension Routing {
    public func handle(route: RouteType) -> SafePromise<Router<RouteType>.RouteResultType> {
        return SafePromise { fulfill in
            self.handle(route: route, completion: fulfill)
        }
    }
}
