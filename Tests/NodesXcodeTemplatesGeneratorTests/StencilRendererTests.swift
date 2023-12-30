//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Nimble
import NodesXcodeTemplatesGenerator
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
                    "ViewStateFactoryTests"
                ]
                templates.forEach { name, template in
                    assertSnapshot(of: template,
                                   as: .lines,
                                   named: "\(name)-\(kind.rawValue)-mockCount-\(count)")
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
                "Context",
                "ContextTests",
                "Flow",
                "FlowTests",
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
            let templates: [String: String] = try stencilRenderer.renderNodeViewInjected(context: context,
                                                                                         includeState: false)
            expect(templates.keys.sorted()) == [
                "Analytics",
                "Builder",
                "Context",
                "Flow"
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
            let templates: [String: String] = try stencilRenderer.renderNodeViewInjected(context: context,
                                                                                         includeState: false)
            expect(templates.keys.sorted()) == [
                "Analytics",
                "Builder",
                "Context",
                "Flow"
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
            let templates: [String: String] = try stencilRenderer.renderNodeViewInjected(context: context,
                                                                                         includeState: false)
            expect(templates.keys.sorted()) == [
                "Analytics",
                "Builder",
                "Context",
                "Flow"
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
        try mockCounts.forEach { count in
            let context: PluginStencilContext = givenPluginStencilContext(mockCount: count)
            assertSnapshot(of: try StencilRenderer().renderPlugin(context: context),
                           as: .lines,
                           named: "mockCount-\(count)")
        }
    }

    func testRenderPluginWithoutReturnType() throws {
        try mockCounts.forEach { count in
            let context: PluginStencilContext = givenPluginStencilContextWithoutReturnType(mockCount: count)
            assertSnapshot(of: try StencilRenderer().renderPlugin(context: context),
                           as: .lines,
                           named: "mockCount-\(count)")
        }
    }

    func testRenderPluginList() throws {
        try mockCounts.forEach { count in
            let context: PluginListStencilContext = givenPluginListStencilContext(mockCount: count)
            assertSnapshot(of: try StencilRenderer().renderPluginList(context: context),
                           as: .lines,
                           named: "mockCount-\(count)")
        }
    }

    func testRenderWorker() throws {
        try mockCounts.forEach { count in
            let context: WorkerStencilContext = givenWorkerStencilContext(mockCount: count)
            assertSnapshot(of: try StencilRenderer().renderWorker(context: context),
                           as: .lines,
                           named: "mockCount-\(count)")
        }
    }
}
