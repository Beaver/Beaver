extension Store {
    /// Responsible of applying side effects for a given action or a state update
    public struct MiddleWare {
        public typealias Run = (_ action: ActionEnvelop<ActionType>?,
                                _ stateUpdate: (oldState: StateType?, newState: StateType)?) -> Void

        public let name: String

        public let run: Run

        public init(name: String, run: @escaping Run) {
            self.name = name
            self.run = run
        }
    }
}
