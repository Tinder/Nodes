//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Nimble
@testable import NodesXcodeTemplatesGenerator
import SnapshotTesting
import XCTest

final class StencilRendererTests: XCTestCase, TestFactories {

    private let mockCounts: ClosedRange<Int> = 0...2

    func testRenderNodeStencil() throws {
        let renderer: StencilRenderer = .init()
        try mockCounts.forEach { count in
            try UIFramework.Kind.allCases.forEach { kind in
                let context: NodeStencilContext = givenNodeStencilContext(mockCount: count)
                let templates: [String: String] = try renderer.renderNodeStencil(context: context,
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
                    assertSnapshot(matching: template,
                                   as: .lines,
                                   named: "\(name)-\(kind.rawValue)-mockCount-\(count)")
                }
            }
        }
    }

    func testRenderNodeRootStencil() throws {
        let renderer: StencilRenderer = .init()
        try mockCounts.forEach { count in
            let context: NodeRootStencilContext = givenNodeRootStencilContext(mockCount: count)
            let templates: [String: String] = try renderer.renderNodeRootStencil(context: context)
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
                               named: "\(name)-UIKit-mockCount-\(count)")
            }
        }
    }

    func testRenderNodeViewInjectedStencil() throws {
        let renderer: StencilRenderer = .init()
        try mockCounts.forEach { count in
            let context: NodeViewInjectedStencilContext = givenNodeViewInjectedStencilContext(mockCount: count)
            let templates: [String: String] = try renderer.renderNodeViewInjectedStencil(context: context,
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
                assertSnapshot(matching: template, as: .lines, named: "\(name)-mockCount-\(count)")
            }
        }
    }

    func testRenderPluginStencil() throws {
        try mockCounts.forEach { count in
            let context: PluginStencilContext = givenPluginStencilContext(mockCount: count)
            assertSnapshot(matching: try StencilRenderer().renderPluginStencil(context: context),
                           as: .lines,
                           named: "mockCount-\(count)")
        }
    }

    func testRenderPluginStencilWithoutReturnType() throws {
        try mockCounts.forEach { count in
            let context: PluginStencilContext = givenPluginStencilContextWithoutReturnType(mockCount: count)
            assertSnapshot(matching: try StencilRenderer().renderPluginStencil(context: context),
                           as: .lines,
                           named: "mockCount-\(count)")
        }
    }

    func testRenderPluginListStencil() throws {
        try mockCounts.forEach { count in
            let context: PluginListStencilContext = givenPluginListStencilContext(mockCount: count)
            assertSnapshot(matching: try StencilRenderer().renderPluginListStencil(context: context),
                           as: .lines,
                           named: "mockCount-\(count)")
        }
    }

    func testRenderWorkerStencil() throws {
        try mockCounts.forEach { count in
            let context: WorkerStencilContext = givenWorkerStencilContext(mockCount: count)
            assertSnapshot(matching: try StencilRenderer().renderWorkerStencil(context: context),
                           as: .lines,
                           named: "mockCount-\(count)")
        }
    }
}
