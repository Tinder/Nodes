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

final class MutableStateTests: XCTestCase {

    private struct TestState: MutableState, Equatable {

        var value: Int
    }

    func testVariableApplyChanges() {
        var state: TestState = .init(value: -1)
        state.apply { $0.value = 23 }
        expect(state) == TestState(value: 23)
    }

    func testConstantApplyingChanges() {
        let state: TestState = .init(value: -1)
        expect(state.applying { $0.value = 23 }) == TestState(value: 23)
    }
}
