//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Nimble
@testable import NodesGenerator
import XCTest

final class StencilContextsTests: XCTestCase, TestFactories {

    func testNodeStencilContext() throws {
        assertSnapshot(of: try givenNodeStencilContext(includePlugin: false).dictionary,
                       as: .dump)
    }

    func testNodeStencilContext_withPlugin() throws {
        assertSnapshot(of: try givenNodeStencilContext(includePlugin: true).dictionary,
                       as: .dump)
    }

    func testNodeStencilContextThrowsReservedNodeName() {
        expect { try self.givenNodeStencilContext(nodeName: "App") }
            .to(throwError(errorType: StencilContextError.self) { error in
                expect(error) == .reservedNodeName("App")
            })
        expect { try self.givenNodeStencilContext(nodeName: "Scene") }
            .to(throwError(errorType: StencilContextError.self) { error in
                expect(error) == .reservedNodeName("Scene")
            })
        expect { try self.givenNodeStencilContext(nodeName: "Window") }
            .to(throwError(errorType: StencilContextError.self) { error in
                expect(error) == .reservedNodeName("Window")
            })
        expect { try self.givenNodeStencilContext(nodeName: "WindowScene") }
            .to(throwError(errorType: StencilContextError.self) { error in
                expect(error) == .reservedNodeName("WindowScene")
            })
        expect { try self.givenNodeStencilContext(nodeName: "Root") }
            .to(throwError(errorType: StencilContextError.self) { error in
                expect(error) == .reservedNodeName("Root")
            })
    }

    func testNodeStencilContextThrowsInvalidPreset() {
        expect { try self.givenNodeStencilContext(preset: .app) }
            .to(throwError(errorType: StencilContextError.self) { error in
                expect(error) == .invalidPreset("App")
            })
        expect { try self.givenNodeStencilContext(preset: .scene) }
            .to(throwError(errorType: StencilContextError.self) { error in
                expect(error) == .invalidPreset("WindowScene")
            })
        expect { try self.givenNodeStencilContext(preset: .window) }
            .to(throwError(errorType: StencilContextError.self) { error in
                expect(error) == .invalidPreset("Window")
            })
    }

    func testNodeViewInjectedStencilContext() throws {
        assertSnapshot(of: try givenNodeViewInjectedStencilContext().dictionary,
                       as: .dump)
    }

    func testNodeViewInjectedStencilContextThrowsReservedNodeName() {
        expect { try self.givenNodeViewInjectedStencilContext(nodeName: "App") }
            .to(throwError(errorType: StencilContextError.self) { error in
                expect(error) == .reservedNodeName("App")
            })
        expect { try self.givenNodeViewInjectedStencilContext(nodeName: "Scene") }
            .to(throwError(errorType: StencilContextError.self) { error in
                expect(error) == .reservedNodeName("Scene")
            })
        expect { try self.givenNodeViewInjectedStencilContext(nodeName: "Window") }
            .to(throwError(errorType: StencilContextError.self) { error in
                expect(error) == .reservedNodeName("Window")
            })
        expect { try self.givenNodeViewInjectedStencilContext(nodeName: "WindowScene") }
            .to(throwError(errorType: StencilContextError.self) { error in
                expect(error) == .reservedNodeName("WindowScene")
            })
        expect { try self.givenNodeViewInjectedStencilContext(nodeName: "Root") }
            .to(throwError(errorType: StencilContextError.self) { error in
                expect(error) == .reservedNodeName("Root")
            })
    }

    func testNodeViewInjectedStencilContextThrowsInvalidPreset() {
        expect { try self.givenNodeViewInjectedStencilContext(preset: .root) }
            .to(throwError(errorType: StencilContextError.self) { error in
                expect(error) == .invalidPreset("Root")
            })
    }

    func testNodePresetAppStencilContext() throws {
        try assertSnapshot(of: givenNodeViewInjectedStencilContext(preset: .app).dictionary,
                           as: .dump)
    }

    func testNodePresetSceneStencilContext() throws {
        try assertSnapshot(of: givenNodeViewInjectedStencilContext(preset: .scene).dictionary,
                           as: .dump)
    }

    func testNodePresetWindowStencilContext() throws {
        try assertSnapshot(of: givenNodeViewInjectedStencilContext(preset: .window).dictionary,
                           as: .dump)
    }

    func testNodePresetRootStencilContext() throws {
        try assertSnapshot(of: givenNodeStencilContext(preset: .root).dictionary,
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
