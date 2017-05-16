import Quick
import Nimble
import BeaverTestKit

@testable import Beaver

final class ViewControllerSpec: QuickSpec {
    override func spec() {
        describe("ViewController") {
            var initialStateMock: StateMock!
            var newStateMock: StateMock!
            var reducerMock: ReducerMock<ActionMock>!
            var storeStub:  StoreStub<ActionMock>!

            var controllerStub: ViewControllerStub<ActionMock>!

            beforeEach {
                initialStateMock = StateMock(name: "initial state")
                newStateMock = StateMock(name: "new state")
                reducerMock = ReducerMock(newStateStub: newStateMock)
                storeStub = StoreStub(initialStateStub: initialStateMock, reducerMock: reducerMock)
                controllerStub = ViewControllerStub(store: storeStub.base)

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
                    expect(reducerMock.envelop?.action) == ActionMock()
                }
            }
        }
    }
}
