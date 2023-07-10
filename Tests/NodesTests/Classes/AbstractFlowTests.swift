//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Nimble
@testable import Nodes
import XCTest

@MainActor
final class AbstractFlowTests: XCTestCase, TestCaseHelpers {

    private class ViewControllerType: Equatable {}

    private class TestFlow: AbstractFlow<ContextMock, ViewControllerType> {

        private(set) var didStartCallCount: Int = 0

        override func didStart() {
            super.didStart()
            didStartCallCount += 1
        }
    }

    private var mockFlows: [FlowMock]!

    override func setUp() {
        super.setUp()
        tearDown(keyPath: \.mockFlows, initialValue: [FlowMock(), FlowMock(), FlowMock()])
    }

    override func tearDown() {
        super.tearDown()
    }

    func testContext() {
        let context: ContextMock = .init()
        expect(context).to(notBeNilAndToDeallocateAfterTest())
        let flow: TestFlow = givenFlow(context: context)
        expect(flow._context as? ContextMock) == context
        expect(flow.context) == context
    }

    func testViewController() {
        let viewController: ViewControllerType = .init()
        expect(viewController).to(notBeNilAndToDeallocateAfterTest())
        let flow: TestFlow = givenFlow(viewController: viewController)
        expect(flow.viewController) == viewController
    }

    func testSubFlows() {
        let flow: TestFlow = givenStartedFlow(subFlows: mockFlows)
        expect(flow.subFlows as? [FlowMock]) == mockFlows
    }

    func testAssertion() {
        expect(AbstractFlow<Void, Void>(context: (), viewController: ())).to(throwAssertion())
    }

    func testStart() {
        let flow: TestFlow = givenFlow()
        expect(flow).toNot(beStarted())
        expect(flow.didStartCallCount) == 0
        expect(flow.context).toNot(beActive())
        flow.start()
        expect(flow).to(beStarted())
        expect(flow.didStartCallCount) == 1
        expect(flow.context).to(beActive())
    }

    func testEnd() {
        let flow: TestFlow = givenStartedFlow()
        expect(flow).to(beStarted())
        expect(flow.context).to(beActive())
        flow.end()
        expect(flow).toNot(beStarted())
        expect(flow.context).toNot(beActive())
    }

    func testAttach() {
        let flow: TestFlow = givenStartedFlow()
        let subFlow: FlowMock = mockFlows[0]
        expect(flow.subFlows).to(beEmpty())
        flow.attach(starting: subFlow)
        expect(flow.subFlows).to(haveCount(1))
    }

    func testDetach() {
        let flow: TestFlow = givenStartedFlow(subFlows: mockFlows)
        let subFlow: FlowMock = mockFlows[1]
        expect(flow.subFlows).to(haveCount(3))
        flow.detach(ending: subFlow)
        expect(flow.subFlows).to(haveCount(2))
    }

    func testDetachEndingSubFlowsOfType() {
        let flow: TestFlow = givenStartedFlow(subFlows: mockFlows)
        let subFlows: [Flow] = flow.subFlows
        expect(flow.subFlows).to(haveCount(3))
        expect(subFlows).to(allBeStarted())
        flow.detach(endingSubFlowsOfType: FlowMock.self) { _ in true }
        expect(subFlows).toNot(allBeStarted())
        expect(flow.subFlows).to(beEmpty())
    }

    func testFirstFlowOfType() {
        let flow: TestFlow = givenStartedFlow(subFlows: mockFlows)
        expect(flow.firstSubFlow(ofType: FlowMock.self)) == mockFlows.first
    }

    func testWithFirstFlowOfType() {
        let flow: TestFlow = givenStartedFlow(subFlows: mockFlows)
        var subFlow: FlowMock?
        flow.withFirstSubFlow(ofType: FlowMock.self) { subFlow = $0 }
        expect(subFlow) == mockFlows.first
    }

    func testFlowsOfType() {
        let flow: TestFlow = givenStartedFlow(subFlows: mockFlows)
        expect(flow.subFlows(ofType: FlowMock.self)) == mockFlows
    }

    func testWithFlowsOfType() {
        let flow: TestFlow = givenStartedFlow(subFlows: mockFlows)
        var flows: [FlowMock] = []
        flow.withSubFlows(ofType: FlowMock.self) { flows.append($0) }
        expect(flows) == mockFlows
    }

    private func givenFlow(
        context: ContextMock? = nil,
        viewController: ViewControllerType? = nil
    ) -> TestFlow {
        let flow: TestFlow
        switch (context, viewController) {
        case let (.some(context), .some(viewController)):
            flow = .init(context: context, viewController: viewController)
        case let (.none, .some(viewController)):
            let context: ContextMock = .init()
            expect(context).to(notBeNilAndToDeallocateAfterTest())
            flow = .init(context: context, viewController: viewController)
        case let (.some(context), .none):
            let viewController: ViewControllerType = .init()
            expect(viewController).to(notBeNilAndToDeallocateAfterTest())
            flow = .init(context: context, viewController: viewController)
        case (.none, .none):
            let context: ContextMock = .init()
            let viewController: ViewControllerType = .init()
            expect(context).to(notBeNilAndToDeallocateAfterTest())
            expect(viewController).to(notBeNilAndToDeallocateAfterTest())
            flow = .init(context: context, viewController: viewController)
        }
        expect(flow).to(notBeNilAndToDeallocateAfterTest())
        addTeardownBlock(with: flow) { flow in
            guard flow.isStarted
            else { return }
            flow.end()
        }
        return flow
    }

    private func givenStartedFlow(subFlows: [FlowMock] = []) -> TestFlow {
        let flow: TestFlow = givenFlow()
        flow.start()
        subFlows.forEach(flow.attach)
        return flow
    }
}
