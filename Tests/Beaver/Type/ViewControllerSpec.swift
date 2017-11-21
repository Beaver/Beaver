import Quick
import Nimble
import BeaverTestKit

@testable import Beaver

final class ViewControllerSpec: QuickSpec {
    override func spec() {
        describe("ViewController") {
            var initialStateMock: AppStateMock!
            var newStateMock: AppStateMock!
            var reducerMock: ReducerMock<AppStateMock>!
            var storeStub: StoreStub<AppStateMock>!

            var controllerStub: ViewControllerStub<StateMock, AppStateMock, ActionMock>!

            beforeEach {
                initialStateMock = AppStateMock(childState: StateMock(name: "initial state"))
                newStateMock = AppStateMock(childState: StateMock(name: "new state"))
                reducerMock = ReducerMock(newStateStub: newStateMock)
                storeStub = StoreStub(initialStateStub: initialStateMock, reducerMock: reducerMock)
                controllerStub = ViewControllerStub(store: ChildStore<StateMock, AppStateMock>(store: storeStub.base) { (appState: AppStateMock) -> StateMock? in
                    return appState.childState
                })

                reducerMock.clear()
                controllerStub.clear()
            }

            describe("dispatch(action:debugInfo:") {
                it("should dispatch an action envelop with debug info") {
                    controllerStub.dispatch(action: ActionMock())

                    expect(reducerMock.envelop?.debugInfo.function).notTo(beEmpty())
                    expect(reducerMock.envelop?.debugInfo.file).notTo(beEmpty())
                    expect(reducerMock.envelop?.debugInfo.line).notTo(equal(0))
                    expect(reducerMock.callCount) == 1
                    expect(reducerMock.envelop?.action as? ActionMock) == ActionMock()
                }
            }
        }
    }
}
