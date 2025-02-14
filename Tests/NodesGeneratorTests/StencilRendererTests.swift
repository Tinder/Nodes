//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

import Nimble
import NodesGenerator
import SnapshotTesting
import XCTest

final class StencilRendererTests: XCTestCase, TestFactories {

    private let mockCounts: ClosedRange<Int> = 0...2

    func testRenderNode() throws {
        let stencilRenderer: StencilRenderer = .init()
        try mockCounts.forEach { count in
            try UIFramework.Kind.allCases.forEach { kind in
                let context: NodeStencilContext = try givenNodeStencilContext(mockCount: count)
                let templates: [String: String] = try stencilRenderer.renderNode(context: context,
                                                                                 kind: kind,
                                                                                 includePlugin: false,
                                                                                 includeTests: false)
                expect(templates.keys.sorted()) == [
                    "Analytics",
                    "Builder",
                    "Context",
                    "Flow",
                    "Interface",
                    "State",
                    "ViewController",
                    "ViewState"
                ]
                templates.forEach { name, template in
                    assertSnapshot(of: template,
                                   as: .lines,
                                   named: "\(name)-\(kind.name.sanitized)-mockCount-\(count)")
                }
            }
        }
    }

    func testRenderNode_withPlugin() throws {
        let stencilRenderer: StencilRenderer = .init()
        try mockCounts.forEach { count in
            try UIFramework.Kind.allCases.forEach { kind in
                let context: NodeStencilContext = try givenNodeStencilContext(mockCount: count)
                let templates: [String: String] = try stencilRenderer.renderNode(context: context,
                                                                                 kind: kind,
                                                                                 includePlugin: true,
                                                                                 includeTests: false)
                expect(templates.keys.sorted()) == [
                    "Analytics",
                    "Builder",
                    "Context",
                    "Flow",
                    "Interface",
                    "Plugin",
                    "State",
                    "ViewController",
                    "ViewState"
                ]
                templates.forEach { name, template in
                    assertSnapshot(of: template,
                                   as: .lines,
                                   named: "\(name)-\(kind.name.sanitized)-mockCount-\(count)")
                }
            }
        }
    }

    func testRenderNode_withTests() throws {
        let stencilRenderer: StencilRenderer = .init()
        try mockCounts.forEach { count in
            try UIFramework.Kind.allCases.forEach { kind in
                let context: NodeStencilContext = try givenNodeStencilContext(mockCount: count)
                let templates: [String: String] = try stencilRenderer.renderNode(context: context,
                                                                                 kind: kind,
                                                                                 includePlugin: false,
                                                                                 includeTests: true)
                expect(templates.keys.sorted()) == [
                    "Analytics",
                    "AnalyticsTests",
                    "Builder",
                    "BuilderTests",
                    "Context",
                    "ContextTests",
                    "Flow",
                    "FlowTests",
                    "Interface",
                    "State",
                    "ViewController",
                    "ViewControllerTests",
                    "ViewState",
                    "ViewStateFactoryTests"
                ]
                templates.forEach { name, template in
                    assertSnapshot(of: template,
                                   as: .lines,
                                   named: "\(name)-\(kind.name.sanitized)-mockCount-\(count)")
                }
            }
        }
    }

    func testRenderNode_withPluginAndTests() throws {
        let stencilRenderer: StencilRenderer = .init()
        try mockCounts.forEach { count in
            try UIFramework.Kind.allCases.forEach { kind in
                let context: NodeStencilContext = try givenNodeStencilContext(mockCount: count)
                let templates: [String: String] = try stencilRenderer.renderNode(context: context,
                                                                                 kind: kind,
                                                                                 includePlugin: true,
                                                                                 includeTests: true)
                expect(templates.keys.sorted()) == [
                    "Analytics",
                    "AnalyticsTests",
                    "Builder",
                    "BuilderTests",
                    "Context",
                    "ContextTests",
                    "Flow",
                    "FlowTests",
                    "Interface",
                    "Plugin",
                    "PluginTests",
                    "State",
                    "ViewController",
                    "ViewControllerTests",
                    "ViewState",
                    "ViewStateFactoryTests"
                ]
                templates.forEach { name, template in
                    assertSnapshot(of: template,
                                   as: .lines,
                                   named: "\(name)-\(kind.name.sanitized)-mockCount-\(count)")
                }
            }
        }
    }

    func testRenderNodeViewInjected() throws {
        let stencilRenderer: StencilRenderer = .init()
        try mockCounts.forEach { count in
            let context: NodeViewInjectedStencilContext = try givenNodeViewInjectedStencilContext(mockCount: count)
            let templates: [String: String] = try stencilRenderer.renderNodeViewInjected(context: context,
                                                                                         includeTests: true)
            expect(templates.keys.sorted()) == [
                "Analytics",
                "AnalyticsTests",
                "Builder",
                "BuilderTests",
                "Context",
                "ContextTests",
                "Flow",
                "FlowTests",
                "Interface",
                "State"
            ]
            templates.forEach { name, template in
                assertSnapshot(of: template, as: .lines, named: "\(name)-mockCount-\(count)")
            }
        }
    }

    func testRenderNodePresetApp() throws {
        let stencilRenderer: StencilRenderer = .init()
        try mockCounts.forEach { count in
            let context: NodeViewInjectedStencilContext = try givenNodeViewInjectedStencilContext(preset: .app,
                                                                                                  mockCount: count)
            let templates: [String: String] = try stencilRenderer.renderNodeViewInjected(context: context)
            expect(templates.keys.sorted()) == [
                "Analytics",
                "Builder",
                "Context",
                "Flow",
                "Interface",
                "State"
            ]
            templates.forEach { name, template in
                assertSnapshot(of: template,
                               as: .lines,
                               named: "\(name)-UIKit-mockCount-\(count)")
            }
        }
    }

    func testRenderNodePresetScene() throws {
        let stencilRenderer: StencilRenderer = .init()
        try mockCounts.forEach { count in
            let context: NodeViewInjectedStencilContext = try givenNodeViewInjectedStencilContext(preset: .scene,
                                                                                                  mockCount: count)
            let templates: [String: String] = try stencilRenderer.renderNodeViewInjected(context: context)
            expect(templates.keys.sorted()) == [
                "Analytics",
                "Builder",
                "Context",
                "Flow",
                "Interface",
                "State"
            ]
            templates.forEach { name, template in
                assertSnapshot(of: template,
                               as: .lines,
                               named: "\(name)-UIKit-mockCount-\(count)")
            }
        }
    }

    func testRenderNodePresetWindow() throws {
        let stencilRenderer: StencilRenderer = .init()
        try mockCounts.forEach { count in
            let context: NodeViewInjectedStencilContext = try givenNodeViewInjectedStencilContext(preset: .window,
                                                                                                  mockCount: count)
            let templates: [String: String] = try stencilRenderer.renderNodeViewInjected(context: context)
            expect(templates.keys.sorted()) == [
                "Analytics",
                "Builder",
                "Context",
                "Flow",
                "Interface",
                "State"
            ]
            templates.forEach { name, template in
                assertSnapshot(of: template,
                               as: .lines,
                               named: "\(name)-UIKit-mockCount-\(count)")
            }
        }
    }

    func testRenderNodePresetRoot() throws {
        let stencilRenderer: StencilRenderer = .init()
        try mockCounts.forEach { count in
            let context: NodeStencilContext = try givenNodeStencilContext(preset: .root, mockCount: count)
            let templates: [String: String] = try stencilRenderer.renderNode(context: context, kind: .uiKit)
            expect(templates.keys.sorted()) == [
                "Analytics",
                "Builder",
                "Context",
                "Flow",
                "Interface",
                "State",
                "ViewController",
                "ViewState"
            ]
            templates.forEach { name, template in
                assertSnapshot(of: template,
                               as: .lines,
                               named: "\(name)-UIKit-mockCount-\(count)")
            }
        }
    }

    func testRenderPlugin() throws {
        let stencilRenderer: StencilRenderer = .init()
        try mockCounts.forEach { count in
            let context: PluginStencilContext = givenPluginStencilContext(mockCount: count)
            let templates: [String: String] = try stencilRenderer
                .renderPlugin(context: context, includeTests: false)
            expect(templates.keys.sorted()) == ["Plugin"]
            templates.forEach { name, template in
                assertSnapshot(of: template,
                               as: .lines,
                               named: "\(name)-mockCount-\(count)")
            }
        }
    }

    func testRenderPlugin_withTests() throws {
        let stencilRenderer: StencilRenderer = .init()
        try mockCounts.forEach { count in
            let context: PluginStencilContext = givenPluginStencilContext(mockCount: count)
            let templates: [String: String] = try stencilRenderer
                .renderPlugin(context: context, includeTests: true)
            expect(templates.keys.sorted()) == ["Plugin", "PluginTests"]
            templates.forEach { name, template in
                assertSnapshot(of: template,
                               as: .lines,
                               named: "\(name)-mockCount-\(count)")
            }
        }
    }

    func testRenderPluginList() throws {
        let stencilRenderer: StencilRenderer = .init()
        try mockCounts.forEach { count in
            let context: PluginListStencilContext = givenPluginListStencilContext(mockCount: count)
            let templates: [String: String] = try stencilRenderer
                .renderPluginList(context: context, includeTests: false)
            expect(templates.keys.sorted()) == ["PluginList"]
            templates.forEach { name, template in
                assertSnapshot(of: template,
                               as: .lines,
                               named: "\(name)-mockCount-\(count)")
            }
        }
    }

    func testRenderPluginList_withTests() throws {
        let stencilRenderer: StencilRenderer = .init()
        try mockCounts.forEach { count in
            let context: PluginListStencilContext = givenPluginListStencilContext(mockCount: count)
            let templates: [String: String] = try stencilRenderer
                .renderPluginList(context: context, includeTests: true)
            expect(templates.keys.sorted()) == ["PluginList", "PluginListTests"]
            templates.forEach { name, template in
                assertSnapshot(of: template,
                               as: .lines,
                               named: "\(name)-mockCount-\(count)")
            }
        }
    }

    func testRenderWorker() throws {
        let stencilRenderer: StencilRenderer = .init()
        try mockCounts.forEach { count in
            let context: WorkerStencilContext = givenWorkerStencilContext(mockCount: count)
            let templates: [String: String] = try stencilRenderer
                .renderWorker(context: context, includeTests: false)
            expect(templates.keys.sorted()) == ["Worker"]
            templates.forEach { name, template in
                assertSnapshot(of: template,
                               as: .lines,
                               named: "\(name)-mockCount-\(count)")
            }
        }
    }

    func testRenderWorker_withTests() throws {
        let stencilRenderer: StencilRenderer = .init()
        try mockCounts.forEach { count in
            let context: WorkerStencilContext = givenWorkerStencilContext(mockCount: count)
            let templates: [String: String] = try stencilRenderer
                .renderWorker(context: context, includeTests: true)
            expect(templates.keys.sorted()) == ["Worker", "WorkerTests"]
            templates.forEach { name, template in
                assertSnapshot(of: template,
                               as: .lines,
                               named: "\(name)-mockCount-\(count)")
            }
        }
    }
}
