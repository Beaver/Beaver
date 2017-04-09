extension Store.Middleware {
    /// A middleware forwarding to an array of middleware
    ///
    /// - Parameter actors: components
    public static func composite(_ middlewares: [Store<ActionType>.Middleware]) -> Store<ActionType>.Middleware {
        let name = middlewares.map {
            $0.name
        }.joined(separator: "__")

        return Store<ActionType>.Middleware(name: name) { action, update in
            for middleWare in middlewares {
                middleWare.run(action, update)
            }
        }
    }
}
