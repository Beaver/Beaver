import Quick
import Nimble
import BeaverTestKit

@testable import Beaver

fileprivate final class DefaultSubscribing: Subscribing {
    typealias ActionType = ActionMock

    private(set) var stateDidUpdateCallCount = 0

    func stateDidUpdate(oldState: Store<ActionMock>.StateType?,
                        newState: Store<ActionMock>.StateType,
                        completion: @escaping () -> ()) {
        stateDidUpdateCallCount += 1
        completion()
    }
}

fileprivate final class StrongSubscribing: Subscribing {
    typealias ActionType = ActionMock

    func stateDidUpdate(oldState: Store<ActionMock>.StateType?,
                        newState: Store<ActionMock>.StateType,
                        completion: @escaping () -> ()) {
        completion()
    }

    let isSubscriptionWeak: Bool = false
}

fileprivate final class ViewControllerSubscribing: UIViewController, Subscribing {
    typealias ActionType = ActionMock

    func stateDidUpdate(oldState: Store<ActionMock>.StateType?,
                        newState: Store<ActionMock>.StateType,
                        completion: @escaping () -> ()) {
        completion()
    }
}

final class SubscriberSpec: QuickSpec {
    private weak var lazyDefaultSubscribing: DefaultSubscribing?

    private weak var lazyStrongSubscribing: StrongSubscribing?

    override func spec() {

        describe("Subscribing") {
            describe("Default implementation") {
                var defaultSubscribing: DefaultSubscribing!

                beforeEach {
                    defaultSubscribing = DefaultSubscribing()
                }

                it("should have a subscription name set to its type name") {
                    expect(defaultSubscribing.subscriptionName).to(contain("DefaultSubscribing"))
                }

                it("should be weak") {
                    expect(defaultSubscribing.isSubscriptionWeak) == true
                }

                describe("subscribe(to:)") {
                    it("should create a weak bound between the subscriber and the store") {
                        self.lazyDefaultSubscribing = defaultSubscribing

                        let stateMock = StateMock.success(SuccessStateMock())
                        let reducerMock = ReducerMock<ActionMock>(newStateStub: stateMock)
                        let store = Store<ActionMock>(initialState: stateMock, reducer: reducerMock.base)

                        defaultSubscribing.subscribe(to: store)

                        expect(self.lazyDefaultSubscribing).notTo(beNil())

                        defaultSubscribing = nil

                        expect(self.lazyDefaultSubscribing).to(beNil())
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

                        let stateMock = StateMock.success(SuccessStateMock())
                        let reducerMock = ReducerMock<ActionMock>(newStateStub: stateMock)
                        let store = Store<ActionMock>(initialState: stateMock, reducer: reducerMock.base)

                        strongSubscribing.subscribe(to: store)

                        expect(self.lazyStrongSubscribing).notTo(beNil())

                        strongSubscribing = nil

                        expect(self.lazyStrongSubscribing).toNot(beNil())
                    }
                }
            }

            describe("Subscribing which is also a UIViewController") {
                it("should be a strong subscriber") {
                    expect(ViewControllerSubscribing().isSubscriptionWeak) == false
                }
            }
        }
    }
}
