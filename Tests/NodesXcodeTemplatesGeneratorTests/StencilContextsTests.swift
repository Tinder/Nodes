//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Nimble
@testable import NodesXcodeTemplatesGenerator
import SnapshotTesting
import XCTest

final class StencilContextsTests: XCTestCase, TestFactories {

    func testNodeStencilContext() throws {
        assertSnapshot(matching: try givenNodeStencilContext().dictionary,
                       as: .dump)
    }

    func testNodeStencilContextWithReservedNodeName() {
        expect { try self.givenNodeStencilContext(nodeName: "Root") }
            .to(throwError(errorType: NodePresetStencilContext.NodePresetStencilContextError.self) { error in
                expect(error) == .reservedNodeName("App")
            })
    }

    func testNodeViewInjectedStencilContext() throws {
        assertSnapshot(matching: try givenNodeViewInjectedStencilContext().dictionary,
                       as: .dump)
    }

    func testNodeViewInjectedStencilContextWithReservedNodeName() {
        expect { try self.givenNodeViewInjectedStencilContext(nodeName: "Root") }
            .to(throwError(errorType: NodePresetStencilContext.NodePresetStencilContextError.self) { error in
                expect(error) == .reservedNodeName("App")
            })
    }

    func testNodePresetRootStencilContext() {
        assertSnapshot(matching: givenNodePresetStencilContext(preset: .root).dictionary,
                       as: .dump)
    }

    func testPluginStencilContext() {
        assertSnapshot(matching: givenPluginStencilContext().dictionary,
                       as: .dump)
    }

    func testPluginStencilContextWithoutReturnType() {
        assertSnapshot(matching: givenPluginStencilContextWithoutReturnType().dictionary,
                       as: .dump)
    }

    func testPluginListStencilContext() {
        assertSnapshot(matching: givenPluginListStencilContext().dictionary,
                       as: .dump)
    }

    func testWorkerStencilContext() {
        assertSnapshot(matching: givenWorkerStencilContext().dictionary,
                       as: .dump)
    }

    func testSortedImports() {
        let imports: Set<String> = [
            "Nodes",
            "struct Combine.AnySubscriber // comment",
            "struct Combine.AnyPublisher",
            "UIKit",
            "lowercase",
            "class Combine.AnyCancellable",
            "Combine",
            "Accelerate",
            "Foundation",
            "protocol Combine.Subscriber // comment",
            "protocol Combine.Publisher"
        ]
        expect(imports.sortedImports()) == [
            "Accelerate",
            "Combine",
            "class Combine.AnyCancellable",
            "protocol Combine.Publisher",
            "protocol Combine.Subscriber // comment",
            "struct Combine.AnyPublisher",
            "struct Combine.AnySubscriber // comment",
            "Foundation",
            "lowercase",
            "Nodes",
            "UIKit"
        ]
    }
}
