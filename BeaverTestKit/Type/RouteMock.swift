import Beaver

public final class RouteSuccessMock: RouteSuccess {
}

public final class RouteErrorMock: RouteError {
}

public final class RouteMock: Route {
    public typealias RouteSuccessType = RouteSuccessMock

    public typealias RouteErrorType = RouteErrorMock
}