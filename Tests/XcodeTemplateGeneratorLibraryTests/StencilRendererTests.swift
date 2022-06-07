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
        let templates: [String: String] = try StencilRenderer().renderNode(context: context)
        expect(templates.keys.sorted()) == [
            "Analytics",
            "Builder",
            "Context",
            "Flow",
            "ViewController",
            "Worker"
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
        assertSnapshot(matching: templates["ViewController"]!,
                       as: .lines,
                       named: "ViewController")
        assertSnapshot(matching: templates["Worker"]!,
                       as: .lines,
                       named: "Worker")
    }

    func testRenderNodeSwiftUI() throws {
        let context: NodeContext = givenNodeContext()
        let templates: [String: String] = try StencilRenderer().renderNode(context: context,
                                                                           swiftUI: true)
        expect(templates.keys.sorted()) == [
            "Analytics",
            "Builder",
            "Context",
            "Flow",
            "ViewController",
            "Worker"
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
        assertSnapshot(matching: templates["ViewController"]!,
                       as: .lines,
                       named: "ViewController")
        assertSnapshot(matching: templates["Worker"]!,
                       as: .lines,
                       named: "Worker")
    }

    func testRenderNodeRoot() throws {
        let context: NodeRootContext = givenNodeRootContext()
        let templates: [String: String] = try StencilRenderer().renderNodeRoot(context: context)
        expect(templates.keys.sorted()) == [
            "Analytics",
            "Builder",
            "Context",
            "Flow",
            "ViewController",
            "Worker"
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
        assertSnapshot(matching: templates["ViewController"]!,
                       as: .lines,
                       named: "ViewController")
        assertSnapshot(matching: templates["Worker"]!,
                       as: .lines,
                       named: "Worker")
    }

    func testRenderNodeViewInjected() throws {
        let context: NodeViewInjectedContext = givenNodeViewInjectedContext()
        let templates: [String: String] = try StencilRenderer().renderNodeViewInjected(context: context)
        expect(templates.keys.sorted()) == [
            "Analytics",
            "Builder",
            "Context",
            "Flow",
            "Worker"
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
        assertSnapshot(matching: templates["Worker"]!,
                       as: .lines,
                       named: "Worker")
    }

    func testRenderNodeWithoutViewState() throws {
        let context: NodeWithoutViewStateContext = givenNodeWithoutViewStateContext()
        let templates: [String: String] = try StencilRenderer().renderNodeWithoutViewState(context: context)
        expect(templates.keys.sorted()) == [
            "Analytics",
            "Builder",
            "Context",
            "Flow",
            "ViewController",
            "Worker"
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
        assertSnapshot(matching: templates["ViewController"]!,
                       as: .lines,
                       named: "ViewController")
        assertSnapshot(matching: templates["Worker"]!,
                       as: .lines,
                       named: "Worker")
    }

    func testRenderNodeWithPlugin() throws {
        let context: NodeWithPluginContext = givenNodeWithPluginContext()
        let templates: [String: String] = try StencilRenderer().renderNodeWithPlugin(context: context)
        expect(templates.keys.sorted()) == [
            "Analytics",
            "Builder",
            "Context",
            "Flow",
            "Plugin",
            "ViewController",
            "Worker"
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
        assertSnapshot(matching: templates["Plugin"]!,
                       as: .lines,
                       named: "Plugin")
        assertSnapshot(matching: templates["ViewController"]!,
                       as: .lines,
                       named: "ViewController")
        assertSnapshot(matching: templates["Worker"]!,
                       as: .lines,
                       named: "Worker")
    }

    func testRenderNodeWithoutViewStateSwiftUI() throws {
        let context: NodeWithoutViewStateContext = givenNodeWithoutViewStateContext()
        let templates: [String: String] = try StencilRenderer().renderNodeWithoutViewState(context: context,
                                                                                           swiftUI: true)
        expect(templates.keys.sorted()) == [
            "Analytics",
            "Builder",
            "Context",
            "Flow",
            "ViewController",
            "Worker"
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
        assertSnapshot(matching: templates["ViewController"]!,
                       as: .lines,
                       named: "ViewController")
        assertSnapshot(matching: templates["Worker"]!,
                       as: .lines,
                       named: "Worker")
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

    func testRenderPluginMap() throws {
        let context: PluginMapContext = givenPluginMapContext()
        assertSnapshot(matching: try StencilRenderer().renderPluginMap(context: context),
                       as: .lines)
    }

    func testRenderWorker() throws {
        let context: WorkerContext = givenWorkerContext()
        assertSnapshot(matching: try StencilRenderer().renderWorker(context: context),
                       as: .lines)
    }
}
