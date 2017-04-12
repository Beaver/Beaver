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
                initialStateMock = .success(SuccessStateMock(name: "initial state"))
                newStateMock = .success(SuccessStateMock(name: "new state"))
                reducerMock = ReducerMock(newStateStub: newStateMock)
                storeStub = StoreStub(initialStateStub: initialStateMock, reducerMock: reducerMock)
                controllerStub = ViewControllerStub(store: storeStub.base)

                reducerMock.clear()
                controllerStub.clear()
            }

            describe("viewDidAppear(animated:)") {
                it("should silently dispatch a didShowView action") {
                    controllerStub.viewDidAppear(false)

                    expect(reducerMock.callCount) == 1
                    expect(reducerMock.envelop?.action) == .lifeCycle(.didShowView)
                    expect(reducerMock.envelop?.payload?["silent"] as? Bool) == true
                }
            }

            describe("viewWillAppear(animated:") {
                it("should silently dispatch a didLoadView action") {
                    controllerStub.viewDidLoad()

                    expect(reducerMock.callCount) == 1
                    expect(reducerMock.envelop?.action) == .lifeCycle(.didLoadView)
                    expect(reducerMock.envelop?.payload?["silent"] as? Bool) == true
                }
            }

            describe("dispatch(action:silent:debugInfo:") {
                it("should dispatch an action envelop with debug info") {
                    controllerStub.dispatch(action: .lifeCycle(.didShowView))

                    expect(reducerMock.envelop?.debugInfo.function).notTo(beEmpty())
                    expect(reducerMock.envelop?.debugInfo.file).notTo(beEmpty())
                    expect(reducerMock.envelop?.debugInfo.line).notTo(equal(0))
                }

                context("when silent is nil") {
                    it("should dispatch an action envelop with silent default value") {
                        controllerStub.dispatch(action: .lifeCycle(.didShowView))

                        expect(controllerStub.isActionSilentCallCount) == 1
                        expect(controllerStub.action) == CoreAction.lifeCycle(.didShowView)
                        expect(reducerMock.callCount) == 1
                        expect(reducerMock.envelop?.action) == CoreAction.lifeCycle(.didShowView)
                        expect(reducerMock.envelop?.payload?["silent"] as? Bool) == true

                        expect(controllerStub.didStartLoadingCallCount) == 1
                        expect(controllerStub.didFinishLoadingCallCount) == 1
                        expect(controllerStub.silent) == true
                    }
                }

                context("when silent is nil") {
                    it("should dispatch an action envelop with silent to false") {
                        controllerStub.dispatch(action: .lifeCycle(.didShowView), silent: false)

                        expect(controllerStub.isActionSilentCallCount) == 0
                        expect(reducerMock.callCount) == 1
                        expect(reducerMock.envelop?.action) == CoreAction.lifeCycle(.didShowView)
                        expect(reducerMock.envelop?.payload?["silent"] as? Bool) == false

                        expect(controllerStub.didStartLoadingCallCount) == 1
                        expect(controllerStub.didFinishLoadingCallCount) == 1
                        expect(controllerStub.silent) == false
                    }
                }
            }
        }
    }
}
