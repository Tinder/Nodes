//
//  ContextsTests.swift
//  XcodeTemplateGeneratorLibraryTests
//
//  Created by Christopher Fuller on 5/31/21.
//

import Nimble
import SnapshotTesting
@testable import XcodeTemplateGeneratorLibrary
import XCTest

final class ContextsTests: XCTestCase, TestFactories {

    func testNodeContext() {
        assertSnapshot(matching: givenNodeContext().dictionary,
                       as: .dump)
    }

    func testNodeWithoutViewContext() {
        assertSnapshot(matching: givenNodeWithoutViewContext().dictionary,
                       as: .dump)
    }

    func testNodeWithoutViewStateContext() {
        assertSnapshot(matching: givenNodeWithoutViewStateContext().dictionary,
                       as: .dump)
    }

    func testPluginContext() {
        assertSnapshot(matching: givenPluginContext().dictionary,
                       as: .dump)
    }

    func testPluginContextWithoutReturnType() {
        assertSnapshot(matching: givenPluginContextWithoutReturnType().dictionary,
                       as: .dump)
    }

    func testPluginListContext() {
        assertSnapshot(matching: givenPluginListContext().dictionary,
                       as: .dump)
    }

    func testPluginMapContext() {
        assertSnapshot(matching: givenPluginMapContext().dictionary,
                       as: .dump)
    }

    func testWorkerContext() {
        assertSnapshot(matching: givenWorkerContext().dictionary,
                       as: .dump)
    }

    func testSortedImports() {
        let imports: Set<String> = [
            "Nodes",
            "struct Combine.AnySubscriber",
            "struct Combine.AnyPublisher",
            "UIKit",
            "lowercase",
            "class Combine.AnyCancellable",
            "Combine",
            "Accelerate",
            "Foundation",
            "protocol Combine.Subscriber",
            "protocol Combine.Publisher"
        ]
        expect(imports.sortedImports()) == [
            "Accelerate",
            "Combine",
            "class Combine.AnyCancellable",
            "protocol Combine.Publisher",
            "protocol Combine.Subscriber",
            "struct Combine.AnyPublisher",
            "struct Combine.AnySubscriber",
            "Foundation",
            "lowercase",
            "Nodes",
            "UIKit"
        ]
    }
}
