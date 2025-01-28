//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

import Combine
import Nimble
import Nodes
import XCTest

final class TransformTests: XCTestCase {

    private class TestTransform: Transform {

        func callAsFunction(_ value: Int) -> String {
            "output: \(value)"
        }
    }

    func testTransformation() {
        let transform: TestTransform = .init()
        expect(transform).to(notBeNilAndToDeallocateAfterTest())
        var output: String?
        _ = Just(23).map(transform).sink { output = $0 }
        expect(output) == "output: 23"
    }
}
