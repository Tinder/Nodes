//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Nimble
@testable import NodesXcodeTemplatesGenerator
import SnapshotTesting
import XCTest

final class StencilRendererTests: XCTestCase, TestFactories {

    func testRenderNode() throws {
        try UIFramework.Kind.allCases.forEach { kind in
            let context: NodeContext = givenNodeContext()
            let templates: [String: String] = try StencilRenderer().renderNode(context: context, kind: kind)
            expect(templates.keys.sorted()) == [
                "Analytics",
                "Builder",
                "Context",
                "Flow",
                "State",
                "ViewController",
                "ViewState"
            ]
            templates.forEach { name, template in
                assertSnapshot(matching: template, as: .lines, named: "\(name)-\(kind.rawValue)")
            }
        }
    }

    func testRenderNodeRoot() throws {
        try (0...2).forEach { count in
            try UIFramework.Kind.allCases.forEach { kind in
                let context: NodeRootContext = givenNodeRootContext(importsCount: count)
                let templates: [String: String] = try StencilRenderer().renderNodeRoot(context: context, kind: kind)
                expect(templates.keys.sorted()) == [
                    "Analytics",
                    "Builder",
                    "Context",
                    "Flow",
                    "State",
                    "ViewController",
                    "ViewState"
                ]
                templates.forEach { name, template in
                    assertSnapshot(matching: template,
                                   as: .lines,
                                   named: "\(name)-\(kind.rawValue)-importsCount-\(count)")
                }
            }
        }
    }

    func testRenderNodeViewInjected() throws {
        let context: NodeViewInjectedContext = givenNodeViewInjectedContext()
        let templates: [String: String] = try StencilRenderer().renderNodeViewInjected(context: context)
        expect(templates.keys.sorted()) == [
            "Analytics",
            "Builder",
            "Context",
            "Flow",
            "State"
        ]
        templates.forEach { name, template in
            assertSnapshot(matching: template, as: .lines, named: name)
        }
    }

    func testRenderPlugin() throws {
        try (0...2).forEach { count in
            let context: PluginContext = givenPluginContext(importsCount: count)
            assertSnapshot(matching: try StencilRenderer().renderPlugin(context: context),
                           as: .lines,
                           named: "importsCount-\(count)")
        }
    }

    func testRenderPluginWithoutReturnType() throws {
        try (0...2).forEach { count in
            let context: PluginContext = givenPluginContextWithoutReturnType(importsCount: count)
            assertSnapshot(matching: try StencilRenderer().renderPlugin(context: context),
                           as: .lines,
                           named: "importsCount-\(count)")
        }
    }

    func testRenderPluginList() throws {
        try (0...2).forEach { count in
            let context: PluginListContext = givenPluginListContext(importsCount: count)
            assertSnapshot(matching: try StencilRenderer().renderPluginList(context: context),
                           as: .lines,
                           named: "importsCount-\(count)")
        }
    }

    func testRenderWorker() throws {
        try (0...2).forEach { count in
            let context: WorkerContext = givenWorkerContext(importsCount: count)
            assertSnapshot(matching: try StencilRenderer().renderWorker(context: context),
                           as: .lines,
                           named: "importsCount-\(count)")
        }
    }
}
