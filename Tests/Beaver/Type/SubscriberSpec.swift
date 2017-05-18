import Quick
import Nimble
import BeaverTestKit

@testable import Beaver

fileprivate final class DefaultSubscribing: Subscribing {
    typealias StateType = StateMock
    typealias ActionType = ActionMock
    typealias ParentStateType = AppStateMock

    private(set) var stateDidUpdateCallCount = 0

    func stateDidUpdate(oldState: StateMock?,
                        newState: StateMock,
                        completion: @escaping () -> ()) {
        stateDidUpdateCallCount += 1
        completion()
    }
}

fileprivate final class ViewControllerSubscribing: UIViewController, Subscribing {
    typealias StateType = StateMock
    typealias ActionType = ActionMock
    typealias ParentStateType = AppStateMock

    func stateDidUpdate(oldState: StateMock?,
                        newState: StateMock,
                        completion: @escaping () -> ()) {
        completion()
    }
}

final class SubscriberSpec: QuickSpec {
    private weak var lazyDefaultSubscribing: DefaultSubscribing?

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

                describe("subscribe(to:)") {
                    it("should create a weak bound between the subscriber and the store") {
                        self.lazyDefaultSubscribing = defaultSubscribing

                        let stateMock = AppStateMock()
                        let reducerMock = ReducerMock<AppStateMock>(newStateStub: stateMock)
                        let store = Store<AppStateMock>(initialState: stateMock, reducer: reducerMock.base)
                        let childStore = ChildStore<StateMock, AppStateMock>(store: store) { (appState: AppStateMock) -> StateMock? in
                            return appState.childState
                        }
                        
                        defaultSubscribing.subscribe(to: childStore)

                        expect(self.lazyDefaultSubscribing).notTo(beNil())

                        defaultSubscribing = nil

                        expect(self.lazyDefaultSubscribing).to(beNil())
                    }
                }
            }
        }
    }
}
