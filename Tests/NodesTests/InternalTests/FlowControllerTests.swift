//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

import Nimble
@testable import Nodes
import XCTest

final class FlowControllerTests: XCTestCase, TestCaseHelpers {

    private var mockFlows: [FlowMock]!

    @MainActor
    override func setUp() {
        super.setUp()
        tearDown(keyPath: \.mockFlows, initialValue: [FlowMock(), FlowMock(), FlowMock()])
    }

    @MainActor
    override func tearDown() {
        super.tearDown()
    }

    @MainActor
    func testFlows() {
        let flowController: FlowController = givenFlowController(with: mockFlows)
        expect(flowController.flows as? [FlowMock]) == mockFlows
    }

    @MainActor
    func testFlowLeakDetection() {
        let flowController: FlowController = givenFlowController(with: mockFlows)
        expect(flowController.isFlowLeakDetectionEnabled) == true
        var called: Bool = false
        flowController.withoutFlowLeakDetection { flowController in
            called = true
            expect(flowController.isFlowLeakDetectionEnabled) == false
        }
        expect(called) == true
        expect(flowController.isFlowLeakDetectionEnabled) == true
    }

    @MainActor
    func testAssertions() {
        let flowController: FlowController = .init()
        let flowA: FlowMock = .init()
        let flowB: FlowMock = .init()
        flowController.attach(starting: flowA)
        expect(flowController.attach(starting: flowA)).to(throwAssertion())
        expect(flowController.detach(ending: flowB)).to(throwAssertion())
    }

    @MainActor
    func testAttach() {
        let flowController: FlowController = givenFlowController()
        let flow: FlowMock = mockFlows[0]
        expect(flowController.flows).to(beEmpty())
        flowController.attach(starting: flow)
        expect(flowController.flows).to(haveCount(1))
    }

    @MainActor
    func testDetach() {
        let flowController: FlowController = givenFlowController(with: mockFlows)
        let flow: FlowMock = mockFlows[1]
        expect(flowController.flows).to(haveCount(3))
        flowController.detach(ending: flow)
        expect(flowController.flows).to(haveCount(2))
    }

    @MainActor
    func testDetachEndingAllFlows() {
        let flowController: FlowController = givenFlowController(with: mockFlows)
        let flows: [Flow] = flowController.flows
        expect(flowController.flows).to(haveCount(3))
        expect(flows).to(allBeStarted())
        flowController.detachEndingAllFlows()
        expect(flows).toNot(allBeStarted())
        expect(flowController.flows).to(beEmpty())
    }

    @MainActor
    func testDetachEndingFlowsOfType() {
        let flowController: FlowController = givenFlowController(with: mockFlows)
        let flows: [Flow] = flowController.flows
        expect(flowController.flows).to(haveCount(3))
        expect(flows).to(allBeStarted())
        flowController.detach(endingFlowsOfType: FlowMock.self) { _ in true }
        expect(flows).toNot(allBeStarted())
        expect(flowController.flows).to(beEmpty())
    }

    @MainActor
    func testFirstFlowOfType() {
        let flowController: FlowController = givenFlowController(with: mockFlows)
        expect(flowController.firstFlow(ofType: FlowMock.self)) === mockFlows.first
    }

    @MainActor
    func testWithFirstFlowOfType() {
        let flowController: FlowController = givenFlowController(with: mockFlows)
        var flow: FlowMock?
        flowController.withFirstFlow(ofType: FlowMock.self) { flow = $0 }
        expect(flow) === mockFlows.first
    }

    @MainActor
    func testFlowsOfType() {
        let flowController: FlowController = givenFlowController(with: mockFlows)
        expect(flowController.flows(ofType: FlowMock.self)) == mockFlows
    }

    @MainActor
    func testWithFlowsOfType() {
        let flowController: FlowController = givenFlowController(with: mockFlows)
        var flows: [FlowMock] = []
        flowController.withFlows(ofType: FlowMock.self) { flows.append($0) }
        expect(flows) == mockFlows
    }

    @MainActor
    private func givenFlowController(with flows: [Flow] = []) -> FlowController {
        let flowController: FlowController = .init()
        expect(flowController).to(notBeNilAndToDeallocateAfterTest())
        flows.forEach(flowController.attach)
        addTeardownBlock(with: flowController) { $0.detachEndingAllFlows() }
        return flowController
    }
}
