import Quick
import Nimble
import BeaverTestKit

@testable import Beaver

fileprivate final class WeakSubscribing: Subscribing {
    typealias StateType = StateMock
    typealias ParentStateType = AppStateMock

    private(set) var stateDidUpdateCallCount = 0

    func stateDidUpdate(oldState: StateMock?,
                        newState: StateMock,
                        completion: @escaping () -> ()) {
        stateDidUpdateCallCount += 1
        completion()
    }
    
    let isSubscriptionWeak: Bool = true
}

fileprivate final class StrongSubscribing: Subscribing {
    typealias StateType = StateMock
    typealias ParentStateType = AppStateMock

    func stateDidUpdate(oldState: StateMock?,
                        newState: StateMock,
                        completion: @escaping () -> ()) {
        completion()
    }

    let isSubscriptionWeak: Bool = false
}

fileprivate final class ViewControllerSubscribing: UIViewController, Subscribing {
    typealias StateType = StateMock
    typealias ParentStateType = AppStateMock

    func stateDidUpdate(oldState: StateMock?,
                        newState: StateMock,
                        completion: @escaping () -> ()) {
        completion()
    }
}

fileprivate final class PresenterSubscribing: Presenting, Subscribing {
    typealias StateType = StateMock
    typealias ParentStateType = AppStateMock

    func stateDidUpdate(oldState: StateMock?,
                        newState: StateMock,
                        completion: @escaping () -> ()) {
        completion()
    }

    let context: Context = ContextMock()
    let store: ChildStore<StateMock, AppStateMock>

    init() {
        let stateMock = AppStateMock()
        let reducerMock = ReducerMock<AppStateMock>(newStateStub: stateMock)
        let store = Store<AppStateMock>(initialState: stateMock, reducer: reducerMock.base)
        self.store = ChildStore<StateMock, AppStateMock>(store: store) { (appState: AppStateMock) -> StateMock? in
            return appState.childState
        }
    }
}

final class SubscriberSpec: QuickSpec {
    private weak var lazyWeakSubscribing: WeakSubscribing?

    private weak var lazyStrongSubscribing: StrongSubscribing?

    override func spec() {
        describe("Subscribing") {
            func childStore() -> ChildStore<StateMock, AppStateMock> {
                let stateMock = AppStateMock()
                let reducerMock = ReducerMock<AppStateMock>(newStateStub: stateMock)
                let store = Store<AppStateMock>(initialState: stateMock, reducer: reducerMock.base)
                return ChildStore<StateMock, AppStateMock>(store: store) { (appState: AppStateMock) -> StateMock? in
                    return appState.childState
                }
            }
            
            describe("Weak implementation") {
                var defaultSubscribing: WeakSubscribing!

                beforeEach {
                    defaultSubscribing = WeakSubscribing()
                }

                it("should have a subscription name set to its type name") {
                    expect(defaultSubscribing.subscriptionName).to(contain("WeakSubscribing"))
                }

                describe("subscribe(to:)") {
                    it("should create a weak bound between the subscriber and the store") {
                        self.lazyWeakSubscribing = defaultSubscribing

   
                        defaultSubscribing.subscribe(to: childStore())

                        expect(self.lazyWeakSubscribing).notTo(beNil())

                        defaultSubscribing = nil

                        expect(self.lazyWeakSubscribing).to(beNil())
                    }
                }
            }

            describe("Overridden implementation") {
                var strongSubscribing: StrongSubscribing!

                beforeEach {
                    strongSubscribing = StrongSubscribing()
                }

                describe("subscribe(to:)") {
                    it("should create a strong bound between the subscriber and the store") {
                        self.lazyStrongSubscribing = strongSubscribing

                        strongSubscribing.subscribe(to: childStore())

                        expect(self.lazyStrongSubscribing).notTo(beNil())

                        strongSubscribing = nil

                        expect(self.lazyStrongSubscribing).toNot(beNil())
                    }
                }
            }

            describe("Subscribing which is also a UIViewController") {
                it("should be a weak subscriber") {
                    expect(ViewControllerSubscribing().isSubscriptionWeak) == true
                }
            }

            describe("Subscribing which is also a Presenter") {
                it("should be a strong subscriber") {
                    expect(PresenterSubscribing().isSubscriptionWeak) == false
                }
            }
        }
    }
}
