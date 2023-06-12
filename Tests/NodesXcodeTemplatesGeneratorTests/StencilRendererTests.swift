//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Nimble
@testable import NodesXcodeTemplatesGenerator
import SnapshotTesting
import XCTest

final class StencilRendererTests: XCTestCase, TestFactories {

    private let importCounts: ClosedRange<Int> = 0...2

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
        try UIFramework.Kind.allCases.forEach { kind in
            let context: NodeRootContext = givenNodeRootContext()
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
                assertSnapshot(matching: template, as: .lines, named: "\(name)-\(kind.rawValue)")
            }
        }
    }

    func testRenderNodeViewInjected() throws {
        try importCounts.forEach { count in
            let context: NodeViewInjectedContext = givenNodeViewInjectedContext(importCount: count)
            let templates: [String: String] = try StencilRenderer().renderNodeViewInjected(context: context)
            expect(templates.keys.sorted()) == [
                "Analytics",
                "Builder",
                "Context",
                "Flow",
                "State"
            ]
            templates.forEach { name, template in
                assertSnapshot(matching: template, as: .lines, named: "\(name)-importCount-\(count)")
            }
        }
    }

    func testRenderPlugin() throws {
        try importCounts.forEach { count in
            let context: PluginContext = givenPluginContext(importCount: count)
            assertSnapshot(matching: try StencilRenderer().renderPlugin(context: context),
                           as: .lines,
                           named: "importCount-\(count)")
        }
    }

    func testRenderPluginWithoutReturnType() throws {
        try importCounts.forEach { count in
            let context: PluginContext = givenPluginContextWithoutReturnType(importCount: count)
            assertSnapshot(matching: try StencilRenderer().renderPlugin(context: context),
                           as: .lines,
                           named: "importCount-\(count)")
        }
    }

    func testRenderPluginList() throws {
        try importCounts.forEach { count in
            let context: PluginListContext = givenPluginListContext(importCount: count)
            assertSnapshot(matching: try StencilRenderer().renderPluginList(context: context),
                           as: .lines,
                           named: "importCount-\(count)")
        }
    }

    func testRenderWorker() throws {
        try importCounts.forEach { count in
            let context: WorkerContext = givenWorkerContext(importCount: count)
            assertSnapshot(matching: try StencilRenderer().renderWorker(context: context),
                           as: .lines,
                           named: "importCount-\(count)")
        }
    }
}
