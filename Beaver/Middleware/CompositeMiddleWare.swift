extension Store.MiddleWare {
    /// A middleware forwarding to an array of middleware
    ///
    /// - Parameter actors: components
    public static func composite(_ middleWares: [Store<ActionType>.MiddleWare]) -> Store<ActionType>.MiddleWare {
        let name = middleWares.map {
            $0.name
        }.joined(separator: "__")

        return Store<ActionType>.MiddleWare(name: name) { action, update in
            for middleWare in middleWares {
                middleWare.run(action, update)
            }
        }
    }
}