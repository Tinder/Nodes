//
//  MutableStateTests.swift
//  NodeTest
//
//  Created by Seppe Snoeck on 09/03/23.
//

import Nimble
@testable import Nodes
import XCTest

final class MutableStateTests: XCTestCase {

    private struct TestState: MutableState, Equatable {
        var value: Int
    }

    func testVariableApplyingMutation() {
        var state: TestState = .init(value: -1)
        state.apply { $0.value = 23 }
        expect(state) == TestState(value: 23)
    }

    func testConstantWithMutation() {
        let state: TestState = .init(value: -1)
        expect(state.with { $0.value = 23 }) == TestState(value: 23)
    }
}
