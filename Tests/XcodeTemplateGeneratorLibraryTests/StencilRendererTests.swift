//
//  StencilRendererTests.swift
//  XcodeTemplateGeneratorLibraryTests
//
//  Created by Christopher Fuller on 5/31/21.
//

import Nimble
import SnapshotTesting
import XcodeTemplateGeneratorLibrary
import XCTest

final class StencilRendererTests: XCTestCase, TestFactories {

    func testRenderNode() throws {
        let context: NodeContext = givenNodeContext()
        let templates: [String: String] = try StencilRenderer().renderNode(context: context, kind: .uiKit)
        expect(templates.keys.sorted()) == [
            "Analytics",
            "Builder",
            "Context",
            "Flow",
            "State",
            "ViewController",
            "ViewState"
        ]
        assertSnapshot(matching: templates["Analytics"]!,
                       as: .lines,
                       named: "Analytics")
        assertSnapshot(matching: templates["Builder"]!,
                       as: .lines,
                       named: "Builder")
        assertSnapshot(matching: templates["Context"]!,
                       as: .lines,
                       named: "Context")
        assertSnapshot(matching: templates["Flow"]!,
                       as: .lines,
                       named: "Flow")
        assertSnapshot(matching: templates["State"]!,
                       as: .lines,
                       named: "State")
        assertSnapshot(matching: templates["ViewController"]!,
                       as: .lines,
                       named: "ViewController")
        assertSnapshot(matching: templates["ViewState"]!,
                       as: .lines,
                       named: "ViewState")
    }

    func testRenderNodeSwiftUI() throws {
        let context: NodeContext = givenNodeContext()
        let templates: [String: String] = try StencilRenderer().renderNode(context: context, kind: .swiftUI)
        expect(templates.keys.sorted()) == [
            "Analytics",
            "Builder",
            "Context",
            "Flow",
            "State",
            "ViewController",
            "ViewState"
        ]
        assertSnapshot(matching: templates["Analytics"]!,
                       as: .lines,
                       named: "Analytics")
        assertSnapshot(matching: templates["Builder"]!,
                       as: .lines,
                       named: "Builder")
        assertSnapshot(matching: templates["Context"]!,
                       as: .lines,
                       named: "Context")
        assertSnapshot(matching: templates["Flow"]!,
                       as: .lines,
                       named: "Flow")
        assertSnapshot(matching: templates["State"]!,
                       as: .lines,
                       named: "State")
        assertSnapshot(matching: templates["ViewController"]!,
                       as: .lines,
                       named: "ViewController")
        assertSnapshot(matching: templates["ViewState"]!,
                       as: .lines,
                       named: "ViewState")
    }

    func testRenderNodeRoot() throws {
        let context: NodeRootContext = givenNodeRootContext()
        let templates: [String: String] = try StencilRenderer().renderNodeRoot(context: context, kind: .uiKit)
        expect(templates.keys.sorted()) == [
            "Analytics",
            "Builder",
            "Context",
            "Flow",
            "State",
            "ViewController",
            "ViewState"
        ]
        assertSnapshot(matching: templates["Analytics"]!,
                       as: .lines,
                       named: "Analytics")
        assertSnapshot(matching: templates["Builder"]!,
                       as: .lines,
                       named: "Builder")
        assertSnapshot(matching: templates["Context"]!,
                       as: .lines,
                       named: "Context")
        assertSnapshot(matching: templates["Flow"]!,
                       as: .lines,
                       named: "Flow")
        assertSnapshot(matching: templates["State"]!,
                       as: .lines,
                       named: "State")
        assertSnapshot(matching: templates["ViewController"]!,
                       as: .lines,
                       named: "ViewController")
        assertSnapshot(matching: templates["ViewState"]!,
                       as: .lines,
                       named: "ViewState")
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
        assertSnapshot(matching: templates["Analytics"]!,
                       as: .lines,
                       named: "Analytics")
        assertSnapshot(matching: templates["Builder"]!,
                       as: .lines,
                       named: "Builder")
        assertSnapshot(matching: templates["Context"]!,
                       as: .lines,
                       named: "Context")
        assertSnapshot(matching: templates["Flow"]!,
                       as: .lines,
                       named: "Flow")
        assertSnapshot(matching: templates["State"]!,
                       as: .lines,
                       named: "State")
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
}
