public final class ChildStore<StateType: State, ParentStateType: State> {
    public typealias Extract = (ParentStateType) -> StateType?

    let extract: Extract

    let store: Store<ParentStateType>

    public init(store: Store<ParentStateType>,
                extract: @escaping Extract) {
        self.store = store
        self.extract = extract
    }
}

// MARK: - Dispatching

extension ChildStore {
    public func dispatch(_ envelop: ActionEnvelop) {
        store.dispatch(envelop)
    }
}

// MARK: - Subscribing

extension ChildStore {
    private func subscriberName(with name: String) -> String {
        return String(describing: self) + "_" + name
    }

    public func subscribe(_ subscriber: Store<StateType>.Subscriber) {
        let store = self.store
        let name = subscriberName(with: subscriber.name)

        let parentSubscriber = Store<ParentStateType>.Subscriber(name: name) { [weak self] oldState, newState, completion in
            if let weakSelf = self {
                let oldChildState = oldState.flatMap(weakSelf.extract)

                if let childState = weakSelf.extract(newState), oldChildState != childState {
                    subscriber.stateDidUpdate(oldChildState, childState, completion)
                } else {
                    completion()
                }
            } else {
                store.unsubscribe(name)
                completion()
            }
        }

        store.subscribe(parentSubscriber)
    }

    public func subscribe(name: String, stateDidUpdate: @escaping Store<StateType>.Subscriber.StateDidUpdate) {
        subscribe(Store<StateType>.Subscriber(name: name, stateDidUpdate: stateDidUpdate))
    }

    public func unsubscribe(_ name: String) {
        store.unsubscribe(subscriberName(with: name))
    }
}

