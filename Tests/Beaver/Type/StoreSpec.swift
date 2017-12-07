import Quick
import Nimble
import BeaverTestKit

@testable import Beaver

final class StoreSpec: QuickSpec {
    override func spec() {
        var initialState: StateMock!

        var newState: StateMock!

        var reducerMock: ReducerMock<StateMock>!

        var store: Store<StateMock>!

        var middlewareMock: MiddlewareMock<StateMock>!
        
        var completionCallCount = 0

        beforeEach {
            initialState = StateMock(name: "initial state")
            newState = StateMock(name: "new state")

            reducerMock = ReducerMock(newStateStub: newState)

            middlewareMock = MiddlewareMock<StateMock>()

            store = Store<StateMock>(initialState: initialState,
                                      middlewares: [middlewareMock.base, middlewareMock.base],
                                      reducer: reducerMock.base)
            
            completionCallCount = 0
        }

        describe("Store<ActionMock>") {
            var subscriberOne: SubscriberMock<StateMock>!

            context("with a synchronous action") {
                context("with one registered subscriber") {
                    beforeEach {
                        subscriberOne = SubscriberMock(name: "SubscriberOne")
                        store.subscribe(subscriberOne.base)
                    }

                    it("should call subscriber one with the initial state") {
                        expect(reducerMock.callCount).toEventually(equal(0))

                        expect(subscriberOne.callCount).toEventually(equal(1))
                        expect(subscriberOne.oldState).toEventually(beNil())
                        expect(subscriberOne.newState).toEventually(equal(initialState))

                        expect(middlewareMock.actions.flatMap { $0 }).toEventually(beEmpty())
                        expect(middlewareMock.stateUpdates[1]?.oldState).toEventually(beNil())
                        expect(middlewareMock.stateUpdates[1]?.newState).toEventually(equal(initialState))
                        expect(middlewareMock.callCount).toEventually(equal(2))
                    }

                    it("should call subscriber one when dispatching an action") {
                        let action = ActionMock()

                        store.dispatch(ActionEnvelop(emitter: "emitter", action: action)) { completionCallCount += 1 }

                        expect(completionCallCount).toEventually(equal(1))

                        expect(reducerMock.callCount).toEventually(equal(1))
                        expect(subscriberOne.callCount).toEventually(equal(2))
                        expect(subscriberOne.oldState).toEventually(equal(initialState))
                        expect(subscriberOne.newState).toEventually(equal(newState))

                        expect(middlewareMock.actions.filter {
                            ($0?.action as? ActionMock).flatMap { a in a == action } == true
                        }.count).toEventually(equal(4))
                        expect(middlewareMock.stateUpdates.filter {
                            $0?.oldState == initialState
                        }.count).toEventually(equal(2))
                        expect(middlewareMock.stateUpdates.filter {
                            $0?.newState == newState
                        }.count).toEventually(equal(2))
                        expect(middlewareMock.callCount).toEventually(equal(6))
                    }

                    context("when initial and new state are the same") {
                        beforeEach {
                            initialState = StateMock(name: "initial state")
                            newState = initialState
                            reducerMock = ReducerMock(newStateStub: newState)
                            store = Store<StateMock>(initialState: initialState,
                                                     middlewares: [middlewareMock.base, middlewareMock.base],
                                                     reducer: reducerMock.base)
                        }

                        it("should not call subscriber one when dispatching an action") {
                            let action = ActionMock()

                            store.dispatch(ActionEnvelop(emitter: "emitter", action: action)) { completionCallCount += 1 }
                            
                            expect(completionCallCount).toEventually(equal(1))
                            
                            expect(reducerMock.callCount).toEventually(equal(1))
                            expect(subscriberOne.callCount).toEventually(equal(1))
                            expect(subscriberOne.oldState).toEventually(beNil())
                            expect(subscriberOne.newState).toEventually(equal(newState))

                            expect(middlewareMock.actions.filter {
                                ($0?.action as? ActionMock).flatMap { a in a == action } == true
                            }.count).toEventually(equal(2))
                            expect(middlewareMock.stateUpdates[1]?.oldState).toEventually(beNil())
                            expect(middlewareMock.stateUpdates[1]?.newState).toEventually(equal(initialState))
                            expect(middlewareMock.callCount).toEventually(equal(6))
                        }
                    }

                    context("with two subscribers") {
                        var subscriberTwo: SubscriberMock<StateMock>!
                        var destScope: ActionEnvelop.Recipients!

                        beforeEach {
                            subscriberTwo = SubscriberMock(name: "SubscriberTwo")
                            store.subscribe(subscriberTwo.base)
                            destScope = .all
                        }

                        context("when dispatching to all") {
                            context("where one is registered, one is unregistered") {
                                beforeEach {
                                    store.unsubscribe(subscriberTwo.base.name)
                                }

                                it("should call subscriber one when dispatching, not subscriber two") {
                                    let action = ActionMock()

                                    store.dispatch(ActionEnvelop(emitter: "emitter", action: action, recipients: destScope)) { completionCallCount += 1 }

                                    expect(completionCallCount).toEventually(equal(1))

                                    expect(reducerMock.callCount).toEventually(equal(1))

                                    expect(subscriberOne.callCount).toEventually(equal(2))
                                    expect(subscriberOne.oldState).toEventually(equal(initialState))
                                    expect(subscriberOne.newState).toEventually(equal(newState))

                                    expect(subscriberTwo.callCount).toEventually(equal(1))
                                    expect(subscriberTwo.oldState).toEventually(beNil())
                                    expect(subscriberTwo.newState).toEventually(equal(initialState))

                                    expect(middlewareMock.actions.filter {
                                        ($0?.action as? ActionMock).flatMap { a in a == action } == true
                                    }.count).toEventually(equal(4))
                                    expect(middlewareMock.stateUpdates.filter {
                                        $0?.oldState == initialState
                                    }.count).toEventually(equal(2))
                                    expect(middlewareMock.stateUpdates.filter {
                                        $0?.newState == newState
                                    }.count).toEventually(equal(2))
                                    expect(middlewareMock.callCount).toEventually(equal(6))
                                }
                            }

                            context("where both are registered") {
                                it("should call both subscribers") {
                                    let action = ActionMock()

                                    store.dispatch(ActionEnvelop(emitter: "emitter", action: action, recipients: destScope)) { completionCallCount += 1 }

                                    expect(completionCallCount).toEventually(equal(1))

                                    expect(reducerMock.callCount).toEventually(equal(1))

                                    expect(subscriberOne.callCount).toEventually(equal(2))
                                    expect(subscriberOne.oldState).toEventually(equal(initialState))
                                    expect(subscriberOne.newState).toEventually(equal(newState))

                                    expect(subscriberTwo.callCount).toEventually(equal(2))
                                    expect(subscriberTwo.oldState).toEventually(equal(initialState))
                                    expect(subscriberTwo.newState).toEventually(equal(newState))

                                    expect(middlewareMock.actions.filter {
                                        ($0?.action as? ActionMock).flatMap { a in a == action } == true
                                    }.count).toEventually(equal(4))
                                    expect(middlewareMock.stateUpdates.filter {
                                        $0?.oldState == initialState
                                    }.count).toEventually(equal(2))
                                    expect(middlewareMock.stateUpdates.filter {
                                        $0?.newState == newState
                                    }.count).toEventually(equal(2))
                                    expect(middlewareMock.callCount).toEventually(equal(6))
                                }
                            }
                        }

                        context("when dispatching to emitter only") {
                            beforeEach {
                                destScope = .emitter
                            }

                            context("where both are registered") {
                                it("should call both subscribers") {
                                    let action = ActionMock()

                                    store.dispatch(ActionEnvelop(emitter: subscriberTwo.name, action: action, recipients: destScope)) { completionCallCount += 1 }

                                    expect(reducerMock.callCount).toEventually(equal(1))

                                    expect(subscriberOne.callCount).toEventually(equal(1))
                                    expect(subscriberOne.oldState).toEventually(beNil())
                                    expect(subscriberOne.newState).toEventually(equal(initialState))

                                    expect(subscriberTwo.callCount).toEventually(equal(2))
                                    expect(subscriberTwo.oldState).toEventually(equal(initialState))
                                    expect(subscriberTwo.newState).toEventually(equal(newState))

                                    expect(middlewareMock.actions.filter {
                                        ($0?.action as? ActionMock).flatMap { a in a == action } == true
                                    }.count).toEventually(equal(4))
                                    expect(middlewareMock.stateUpdates.filter {
                                        $0?.oldState == initialState
                                    }.count).toEventually(equal(2))
                                    expect(middlewareMock.stateUpdates.filter {
                                        $0?.newState == newState
                                    }.count).toEventually(equal(2))
                                    expect(middlewareMock.callCount).toEventually(equal(6))
                                }
                            }
                        }

                        context("when dispatching all excluding emitter") {
                            beforeEach {
                                destScope = .allExcludingEmitter
                            }

                            context("where both are registered") {
                                it("should call both subscribers") {
                                    let action = ActionMock()

                                    store.dispatch(ActionEnvelop(emitter: subscriberOne.name, action: action, recipients: destScope)) { completionCallCount += 1 }

                                    expect(reducerMock.callCount).toEventually(equal(1))

                                    expect(reducerMock.callCount).toEventually(equal(1))

                                    expect(subscriberOne.callCount).toEventually(equal(1))
                                    expect(subscriberOne.oldState).toEventually(beNil())
                                    expect(subscriberOne.newState).toEventually(equal(initialState))

                                    expect(subscriberTwo.callCount).toEventually(equal(2))
                                    expect(subscriberTwo.oldState).toEventually(equal(initialState))
                                    expect(subscriberTwo.newState).toEventually(equal(newState))

                                    expect(middlewareMock.actions.filter {
                                        ($0?.action as? ActionMock).flatMap { a in a == action } == true
                                    }.count).toEventually(equal(4))
                                    expect(middlewareMock.stateUpdates.filter {
                                        $0?.oldState == initialState
                                    }.count).toEventually(equal(2))
                                    expect(middlewareMock.stateUpdates.filter {
                                        $0?.newState == newState
                                    }.count).toEventually(equal(2))
                                    expect(middlewareMock.callCount).toEventually(equal(6))
                                }
                            }
                        }
                        
                        context("when dispatching to a list of subscribers") {
                            beforeEach {
                                destScope = .authorized(to: Set([subscriberTwo.name]))
                            }
                            
                            context("where both are registered") {
                                it("should call both subscribers") {
                                    let action = ActionMock()
                                    
                                    store.dispatch(ActionEnvelop(emitter: "emitter", action: action, recipients: destScope)) { completionCallCount += 1 }
                                    
                                    expect(reducerMock.callCount).toEventually(equal(1))
                                    
                                    expect(reducerMock.callCount).toEventually(equal(1))
                                    
                                    expect(subscriberOne.callCount).toEventually(equal(1))
                                    expect(subscriberOne.oldState).toEventually(beNil())
                                    expect(subscriberOne.newState).toEventually(equal(initialState))
                                    
                                    expect(subscriberTwo.callCount).toEventually(equal(2))
                                    expect(subscriberTwo.oldState).toEventually(equal(initialState))
                                    expect(subscriberTwo.newState).toEventually(equal(newState))
                                    
                                    expect(middlewareMock.actions.filter {
                                        ($0?.action as? ActionMock).flatMap { a in a == action } == true
                                    }.count).toEventually(equal(4))
                                    expect(middlewareMock.stateUpdates.filter {
                                        $0?.oldState == initialState
                                    }.count).toEventually(equal(2))
                                    expect(middlewareMock.stateUpdates.filter {
                                        $0?.newState == newState
                                    }.count).toEventually(equal(2))
                                    expect(middlewareMock.callCount).toEventually(equal(6))
                                }
                            }
                        }
                    }
                }
            }

            context("with an asynchronous action") {
                var completedState: StateMock!
                
                beforeEach {
                    completedState = StateMock(name: "completed state")
                    reducerMock.newCompletedStateStub = completedState
                }

                context("with one registered subscriber") {
                    beforeEach {
                        subscriberOne = SubscriberMock(name: "SubscriberOne")
                        store.subscribe(subscriberOne.base)
                    }

                    it("should call subscriber one synchronously and asynchronously when dispatching an action") {
                        let action = ActionMock()

                        store.dispatch(ActionEnvelop(emitter: "emitter", action: action)) { completionCallCount += 1 }

                        expect(reducerMock.callCount).toEventually(equal(1))
                        
                        expect(reducerMock.callCount).toEventually(equal(1))
                        expect(subscriberOne.callCount).toEventually(equal(3))
                        expect(subscriberOne.oldState).toEventually(equal(newState))
                        expect(subscriberOne.newState).toEventually(equal(completedState))

                        expect(middlewareMock.actions.filter {
                            ($0?.action as? ActionMock).flatMap { a in a == action } == true
                        }.count).toEventually(equal(6))
                        expect(middlewareMock.stateUpdates.filter {
                            $0?.oldState == initialState
                        }.count).toEventually(equal(2))
                        expect(middlewareMock.stateUpdates.filter {
                            $0?.newState == newState
                        }.count).toEventually(equal(2))
                        expect(middlewareMock.callCount).toEventually(equal(8))
                    }
                }
            }
        }
    }
}

