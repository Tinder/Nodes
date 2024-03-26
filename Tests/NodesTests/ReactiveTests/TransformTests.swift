//
//  Copyright © 2022 Tinder (Match Group, LLC)
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
