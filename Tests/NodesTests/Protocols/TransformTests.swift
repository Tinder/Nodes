//
//  TransformTests.swift
//  NodeTests
//
//  Created by Christopher Fuller on 6/30/22.
//

import Combine
import Nimble
@testable import Nodes
import XCTest

@available(macOS 10.15, macCatalyst 13.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final class TransformTests: XCTestCase {

    private class TestTransform: Transform {

        func callAsFunction(_ input: TestInput) -> String {
            "output: \(input.value)"
        }
    }

    private struct TestInput: InitialStateProviding {

        static var initialState: TestInput = .init(value: 99)

        var value: Int
    }

    func testTransformation() {
        let input: TestInput = .init(value: 23)
        let transform: TestTransform = .init()
        expect(transform).to(notBeNilAndToDeallocateAfterTest())
        var output: String?
        _ = Just(input).map(transform).sink { output = $0 }
        expect(output) == "output: 23"
    }

    func testInitialState() {
        let transform: TestTransform = .init()
        expect(transform).to(notBeNilAndToDeallocateAfterTest())
        expect(transform.initialState) == "output: 99"
    }
}
