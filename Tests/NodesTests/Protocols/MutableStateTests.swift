//
//  MutableStateTests.swift
//  NodeTest
//
//  Created by Seppe Snoeck on 09/03/23.
//

import Combine
import Nimble
@testable import Nodes
import XCTest

final class MutableStateTests: XCTestCase {
    private struct TestState: MutableState, Equatable {
        var value: Int
    }

    func testMutableState() {
        let subject: Combine.CurrentValueSubject<TestState, Never> = .init(TestState(value: -1))
        subject.value.apply { $0.value = 23 }
        XCTAssertEqual(subject.value, TestState(value: 23))
    }
}
