extension Store.Middleware {
    /// A MiddleWare logging every actions and state updates
    public static var logging: Store<ActionType>.Middleware {
        return Store<ActionType>.Middleware(name: "LoggingMiddleware") { action, update in
#if DEBUG
            print(">>>>>>>>>>>")
            print("action: \(String(describing: action))")
            if let update = update {
                print("-----------")
                print("old state: \(String(describing: update.oldState))")
                print("-----------")
                print("new state: \(update.newState)")
            }
            print("<<<<<<<<<<<")
#endif
        }
    }
}
