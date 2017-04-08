extension Store {
    /// An object observing state updates
    public struct Subscriber {
        /// Called when the store's state changed
        ///
        /// - Parameters:
        ///     - source: action that generated the state update
        ///     - oldState: previous state
        ///     - newState: generated state
        public typealias StateDidUpdate = (_ source: ActionEnvelop<ActionType>?,
                                           _ oldState: StateType?,
                                           _ newState: StateType) -> ()

        public let name: String

        public let stateDidUpdate: StateDidUpdate

        public init(name: String,
                    stateDidUpdate: @escaping StateDidUpdate) {
            self.name = name
            self.stateDidUpdate = stateDidUpdate
        }
    }
}

// MARK: - Equatable

extension Store.Subscriber: Equatable {
    public static func ==(lhs: Store<ActionType>.Subscriber, rhs: Store<ActionType>.Subscriber) -> Bool {
        return lhs.name == rhs.name
    }
}

// MARK: - Hashable

extension Store.Subscriber: Hashable {
    public var hashValue: Int {
        return name.hashValue
    }
}

// MARK: - Description

extension Store.Subscriber: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "\(name)"
    }
}
