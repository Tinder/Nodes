//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Nimble
@testable import Nodes
import XCTest

@MainActor
final class FlowControllerTests: XCTestCase, TestCaseHelpers {

    private var mockFlows: [FlowMock]!

    override func setUp() {
        super.setUp()
        tearDown(keyPath: \.mockFlows, initialValue: [FlowMock(), FlowMock(), FlowMock()])
    }

    override func tearDown() {
        super.tearDown()
    }

    func testFlows() {
        let flowController: FlowController = givenFlowController(with: mockFlows)
        expect(flowController.flows as? [FlowMock]) == mockFlows
    }

    func testFlowLeakDetection() {
        let flowController: FlowController = givenFlowController(with: mockFlows)
        expect(flowController.isFlowLeakDetectionEnabled) == true
        // swiftlint:disable:next redundant_type_annotation
        var called: Bool = false
        flowController.withoutFlowLeakDetection { flowController in
            called = true
            expect(flowController.isFlowLeakDetectionEnabled) == false
        }
        expect(called) == true
        expect(flowController.isFlowLeakDetectionEnabled) == true
    }

    func testAssertions() {
        let flowController: FlowController = .init()
        let flow: FlowMock = .init()
        flowController.attach(starting: flow)
        expect(flowController.attach(starting: flow)).to(throwAssertion())
        expect(flowController.detach(ending: FlowMock())).to(throwAssertion())
    }

    func testAttach() {
        let flowController: FlowController = givenFlowController()
        expect(flowController.flows).to(beEmpty())
        flowController.attach(starting: FlowMock())
        expect(flowController.flows).to(haveCount(1))
    }

    func testDetach() {
        let flowController: FlowController = givenFlowController(with: mockFlows)
        let subFlow: FlowMock = mockFlows[1]
        expect(flowController.flows).to(haveCount(3))
        flowController.detach(ending: subFlow)
        expect(flowController.flows).to(haveCount(2))
    }

    func testDetachEndingFlowsOfType() {
        let flowController: FlowController = givenFlowController(with: mockFlows)
        let flows: [Flow] = flowController.flows
        expect(flowController.flows).to(haveCount(3))
        expect(flows).to(allBeStarted())
        flowController.detach(endingFlowsOfType: FlowMock.self) { _ in true }
        expect(flows).toNot(allBeStarted())
        expect(flowController.flows).to(beEmpty())
    }

    func testFirstFlowOfType() {
        let flowController: FlowController = givenFlowController(with: mockFlows)
        expect(flowController.firstFlow(ofType: FlowMock.self)) == mockFlows.first
    }

    func testWithFirstFlowOfType() {
        let flowController: FlowController = givenFlowController(with: mockFlows)
        var flow: FlowMock?
        flowController.withFirstFlow(ofType: FlowMock.self) { flow = $0 }
        expect(flow) == mockFlows.first
    }

    func testFlowsOfType() {
        let flowController: FlowController = givenFlowController(with: mockFlows)
        expect(flowController.flows(ofType: FlowMock.self)) == mockFlows
    }

    func testWithFlowsOfType() {
        let flowController: FlowController = givenFlowController(with: mockFlows)
        var flows: [FlowMock] = []
        flowController.withFlows(ofType: FlowMock.self) { flows.append($0) }
        expect(flows) == mockFlows
    }

    func testDeinit() {
        var flowController: FlowController! = givenFlowController(with: mockFlows)
        let flows: [Flow] = flowController.flows
        expect(flows).to(allBeStarted())
        flowController = nil
        expect(flows).toNot(allBeStarted())
    }

    private func givenFlowController(with flows: [Flow] = []) -> FlowController {
        let flowController: FlowController = .init()
        expect(flowController).to(notBeNilAndToDeallocateAfterTest())
        flows.forEach(flowController.attach)
        return flowController
    }
}
