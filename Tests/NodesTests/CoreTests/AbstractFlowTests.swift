//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

import Nimble
import Nodes
import XCTest

final class AbstractFlowTests: XCTestCase, TestCaseHelpers {

    private class ViewControllerType {}

    private class TestFlow: AbstractFlow<ContextMock, ViewControllerType> {

        private(set) var didStartCallCount: Int = 0

        override func didStart() {
            super.didStart()
            didStartCallCount += 1
        }
    }

    private var mockFlows: [FlowMock]!

    override func setUp() async throws {
        try await super.setUp()
        struct Box<T: XCTestCase>: @unchecked Sendable {
            let testCase: T
        }
        let box: Box<AbstractFlowTests> = .init(testCase: self)
        _ = await Task { @MainActor in
            let testCase: AbstractFlowTests = box.testCase
            testCase.tearDown(
                keyPath: \.mockFlows,
                initialValue: [FlowMock(), FlowMock(), FlowMock()]
            )
        }.result
    }

    override func tearDown() async throws {
        try await super.tearDown()
    }

    @MainActor
    func testContext() {
        let context: ContextMock = .init()
        expect(context).to(notBeNilAndToDeallocateAfterTest())
        let flow: TestFlow = givenFlow(context: context)
        expect(flow._context as? ContextMock) === context
        expect(flow.context) === context
    }

    @MainActor
    func testViewController() {
        let viewController: ViewControllerType = .init()
        expect(viewController).to(notBeNilAndToDeallocateAfterTest())
        let flow: TestFlow = givenFlow(viewController: viewController)
        expect(flow.viewController) === viewController
    }

    @MainActor
    func testSubFlows() {
        let flow: TestFlow = givenStartedFlow(subFlows: mockFlows)
        expect(flow.subFlows as? [FlowMock]) == mockFlows
    }

    @MainActor
    func testAssertion() {
        expect(AbstractFlow<Void, Void>(context: (), viewController: ())).to(throwAssertion())
    }

    @MainActor
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

    @MainActor
    func testEnd() {
        let flow: TestFlow = givenStartedFlow()
        expect(flow).to(beStarted())
        expect(flow.context).to(beActive())
        flow.end()
        expect(flow).toNot(beStarted())
        expect(flow.context).toNot(beActive())
    }

    @MainActor
    func testAttach() {
        let flow: TestFlow = givenStartedFlow()
        let subFlow: FlowMock = mockFlows[0]
        expect(flow.subFlows).to(beEmpty())
        flow.attach(starting: subFlow)
        expect(flow.subFlows).to(haveCount(1))
    }

    @MainActor
    func testDetach() {
        let flow: TestFlow = givenStartedFlow(subFlows: mockFlows)
        let subFlow: FlowMock = mockFlows[1]
        expect(flow.subFlows).to(haveCount(3))
        flow.detach(ending: subFlow)
        expect(flow.subFlows).to(haveCount(2))
    }

    @MainActor
    func testDetachEndingSubFlowsOfType() {
        let flow: TestFlow = givenStartedFlow(subFlows: mockFlows)
        let subFlows: [Flow] = flow.subFlows
        expect(flow.subFlows).to(haveCount(3))
        expect(subFlows).to(allBeStarted())
        flow.detach(endingSubFlowsOfType: FlowMock.self) { _ in true }
        expect(subFlows).toNot(allBeStarted())
        expect(flow.subFlows).to(beEmpty())
    }

    @MainActor
    func testFirstFlowOfType() {
        let flow: TestFlow = givenStartedFlow(subFlows: mockFlows)
        expect(flow.firstSubFlow(ofType: FlowMock.self)) == mockFlows.first
    }

    @MainActor
    func testWithFirstFlowOfType() {
        let flow: TestFlow = givenStartedFlow(subFlows: mockFlows)
        var subFlow: FlowMock?
        flow.withFirstSubFlow(ofType: FlowMock.self) { subFlow = $0 }
        expect(subFlow) == mockFlows.first
    }

    @MainActor
    func testFlowsOfType() {
        let flow: TestFlow = givenStartedFlow(subFlows: mockFlows)
        expect(flow.subFlows(ofType: FlowMock.self)) == mockFlows
    }

    @MainActor
    func testWithFlowsOfType() {
        let flow: TestFlow = givenStartedFlow(subFlows: mockFlows)
        var flows: [FlowMock] = []
        flow.withSubFlows(ofType: FlowMock.self) { flows.append($0) }
        expect(flows) == mockFlows
    }

    @MainActor
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

    @MainActor
    private func givenStartedFlow(subFlows: [FlowMock] = []) -> TestFlow {
        let flow: TestFlow = givenFlow()
        flow.start()
        subFlows.forEach(flow.attach)
        return flow
    }
}
