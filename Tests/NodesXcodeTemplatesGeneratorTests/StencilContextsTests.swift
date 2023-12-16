//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Nimble
@testable import NodesXcodeTemplatesGenerator
import SnapshotTesting
import XCTest

final class StencilContextsTests: XCTestCase, TestFactories {

    func testNodeStencilContext() throws {
        assertSnapshot(of: try givenNodeStencilContext().dictionary,
                       as: .dump)
    }

    func testNodeStencilContextWithReservedNodeName() {
        expect { try self.givenNodeStencilContext(nodeName: "Root") }
            .to(throwError(errorType: StencilContextError.self) { error in
                expect(error) == .reservedNodeName("Root")
            })
    }

    func testNodeViewInjectedStencilContext() throws {
        assertSnapshot(of: try givenNodeViewInjectedStencilContext().dictionary,
                       as: .dump)
    }

    func testNodeViewInjectedStencilContextWithReservedNodeName() {
        expect { try self.givenNodeViewInjectedStencilContext(nodeName: "Root") }
            .to(throwError(errorType: StencilContextError.self) { error in
                expect(error) == .reservedNodeName("Root")
            })
    }

    func testNodePresetAppStencilContext() {
        assertSnapshot(of: givenNodePresetStencilContext(preset: .app).dictionary,
                       as: .dump)
    }

    func testNodePresetSceneStencilContext() {
        assertSnapshot(of: givenNodePresetStencilContext(preset: .scene).dictionary,
                       as: .dump)
    }

    func testNodePresetWindowStencilContext() {
        assertSnapshot(of: givenNodePresetStencilContext(preset: .window).dictionary,
                       as: .dump)
    }

    func testNodePresetRootStencilContext() {
        assertSnapshot(of: givenNodePresetStencilContext(preset: .root).dictionary,
                       as: .dump)
    }

    func testPluginStencilContext() {
        assertSnapshot(of: givenPluginStencilContext().dictionary,
                       as: .dump)
    }

    func testPluginStencilContextWithoutReturnType() {
        assertSnapshot(of: givenPluginStencilContextWithoutReturnType().dictionary,
                       as: .dump)
    }

    func testPluginListStencilContext() {
        assertSnapshot(of: givenPluginListStencilContext().dictionary,
                       as: .dump)
    }

    func testWorkerStencilContext() {
        assertSnapshot(of: givenWorkerStencilContext().dictionary,
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
