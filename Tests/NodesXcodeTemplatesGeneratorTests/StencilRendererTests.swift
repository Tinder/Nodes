//
//  StencilRendererTests.swift
//  NodesXcodeTemplatesGeneratorTests
//
//  Created by Christopher Fuller on 5/31/21.
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
        let context: PluginContext = givenPluginContext()
        assertSnapshot(matching: try StencilRenderer().renderPlugin(context: context),
                       as: .lines)
    }

    func testRenderPluginList() throws {
        let context: PluginListContext = givenPluginListContext()
        assertSnapshot(matching: try StencilRenderer().renderPluginList(context: context),
                       as: .lines)
    }

    func testRenderWorker() throws {
        let context: WorkerContext = givenWorkerContext()
        assertSnapshot(matching: try StencilRenderer().renderWorker(context: context),
                       as: .lines)
    }

    func testRenderNodeImportsCount() throws {
        try [0, 1, 2].forEach { count in
            let context: NodeContext = givenNodeContext(imports: count)
            let templates: [String: String] = try StencilRenderer().renderNode(context: context, kind: .uiKit)
            templates.forEach { name, template in
                assertSnapshot(matching: template, as: .lines, named: "\(name)-\(count + 1)")
            }
        }
    }

    func testRenderNodeDependenciesCount() throws {
        try [0, 1, 2].forEach { count in
            let context: NodeContext = givenNodeContext(dependencies: count)
            let templates: [String: String] = try StencilRenderer().renderNode(context: context, kind: .uiKit)
            templates[StencilTemplate.builder(.default).name].flatMap { template in
                assertSnapshot(matching: template, as: .lines, named: "\(count)")
            }
        }
    }

    func testRenderNodeFlowProperties() throws {
        try [0, 1, 2].forEach { count in
            let context: NodeContext = givenNodeContext(flowProperties: count)
            let templates: [String: String] = try StencilRenderer().renderNode(context: context, kind: .uiKit)
            [StencilTemplate.builder(.default).name, StencilTemplate.flow.name].forEach { name in
                templates[name].flatMap { template in
                    assertSnapshot(matching: template, as: .lines, named: "\(name)-count-\(count)")
                }
            }
        }
    }
}
