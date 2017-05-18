extension Store.Middleware {
    /// A middleware forwarding to an array of middleware
    ///
    /// - Parameter actors: components
    public static func composite(_ middlewares: [Store<StateType>.Middleware]) -> Store<StateType>.Middleware {
        let name = middlewares.map {
            $0.name
        }.joined(separator: "__")

        return Store<StateType>.Middleware(name: name) { action, update in
            for middleWare in middlewares {
                middleWare.run(action, update)
            }
        }
    }
}
