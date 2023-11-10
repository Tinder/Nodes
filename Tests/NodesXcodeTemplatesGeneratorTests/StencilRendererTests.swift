//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Nimble
@testable import NodesXcodeTemplatesGenerator
import SnapshotTesting
import XCTest

final class StencilRendererTests: XCTestCase, TestFactories {

    private let mockCounts: ClosedRange<Int> = 0...2

    func testRenderNode() throws {
        let renderer: StencilRenderer = .init()
        try mockCounts.forEach { count in
            try UIFramework.Kind.allCases.forEach { kind in
                let context: NodeContext = givenNodeContext(mockCount: count)
                let templates: [String: String] = try renderer.renderNode(context: context,
                                                                          kind: kind,
                                                                          includeTests: true)
                expect(templates.keys.sorted()) == [
                    "Analytics",
                    "AnalyticsTests",
                    "Builder",
                    "Context",
                    "ContextTests",
                    "Flow",
                    "FlowTests",
                    "State",
                    "ViewController",
                    "ViewControllerTests",
                    "ViewState",
                    "ViewStateTests"
                ]
                templates.forEach { name, template in
                    assertSnapshot(matching: template,
                                   as: .lines,
                                   named: "\(name)-\(kind.rawValue)-mockCount-\(count)")
                }
            }
        }
    }

    func testRenderNodeRoot() throws {
        let renderer: StencilRenderer = .init()
        try mockCounts.forEach { count in
            try UIFramework.Kind.allCases.forEach { kind in
                let context: NodeRootContext = givenNodeRootContext(mockCount: count)
                let templates: [String: String] = try renderer.renderNodeRoot(context: context,
                                                                              kind: kind,
                                                                              includeTests: true)
                expect(templates.keys.sorted()) == [
                    "Analytics",
                    "AnalyticsTests",
                    "Builder",
                    "Context",
                    "ContextTests",
                    "Flow",
                    "FlowTests",
                    "State",
                    "ViewController",
                    "ViewControllerTests",
                    "ViewState",
                    "ViewStateTests"
                ]
                templates.forEach { name, template in
                    assertSnapshot(matching: template,
                                   as: .lines,
                                   named: "\(name)-\(kind.rawValue)-mockCount-\(count)")
                }
            }
        }
    }

    func testRenderNodeViewInjected() throws {
        let renderer: StencilRenderer = .init()
        try mockCounts.forEach { count in
            let context: NodeViewInjectedContext = givenNodeViewInjectedContext(mockCount: count)
            let templates: [String: String] = try renderer.renderNodeViewInjected(context: context, includeTests: true)
            expect(templates.keys.sorted()) == [
                "Analytics",
                "AnalyticsTests",
                "Builder",
                "Context",
                "ContextTests",
                "Flow",
                "FlowTests",
                "State"
            ]
            templates.forEach { name, template in
                assertSnapshot(matching: template, as: .lines, named: "\(name)-mockCount-\(count)")
            }
        }
    }

    func testRenderPlugin() throws {
        try mockCounts.forEach { count in
            let context: PluginContext = givenPluginContext(mockCount: count)
            assertSnapshot(matching: try StencilRenderer().renderPlugin(context: context),
                           as: .lines,
                           named: "mockCount-\(count)")
        }
    }

    func testRenderPluginWithoutReturnType() throws {
        try mockCounts.forEach { count in
            let context: PluginContext = givenPluginContextWithoutReturnType(mockCount: count)
            assertSnapshot(matching: try StencilRenderer().renderPlugin(context: context),
                           as: .lines,
                           named: "mockCount-\(count)")
        }
    }

    func testRenderPluginList() throws {
        try mockCounts.forEach { count in
            let context: PluginListContext = givenPluginListContext(mockCount: count)
            assertSnapshot(matching: try StencilRenderer().renderPluginList(context: context),
                           as: .lines,
                           named: "mockCount-\(count)")
        }
    }

    func testRenderWorker() throws {
        try mockCounts.forEach { count in
            let context: WorkerContext = givenWorkerContext(mockCount: count)
            assertSnapshot(matching: try StencilRenderer().renderWorker(context: context),
                           as: .lines,
                           named: "mockCount-\(count)")
        }
    }
}
