//
//  PluginListTests.swift
//  NodeTests
//
//  Created by Christopher Fuller on 5/4/21.
//

import Nimble
@testable import Nodes
import XCTest

final class PluginListTests: XCTestCase, TestCaseHelpers {

    private class ComponentType {}

    private class BuildType {

        var identifier: String

        init(identifier: String) {
            self.identifier = identifier
        }
    }

    private class TestPluginList: PluginList<String, ComponentType, BuildType, Void> {

        // swiftlint:disable:next discouraged_optional_collection
        var creationOrderOverride: [String]?

        override func plugins(component: ComponentType) -> KeyValuePairs<String, AnyPlugin> {
            [
                "plugin1": AnyPlugin(BuildType(identifier: "plugin1")),
                "plugin2": AnyPlugin(BuildType(identifier: "plugin2")),
                "plugin3": AnyPlugin(BuildType(identifier: "plugin3"))
            ]
        }

        override func creationOrder(component: ComponentType) -> [String] {
            creationOrderOverride ?? super.creationOrder(component: component)
        }
    }

    private class TestPluginListWithDefault: PluginListWithDefault<String, ComponentType, BuildType, Void> {

        // swiftlint:disable:next discouraged_optional_collection
        var creationOrderOverride: [String]?

        override func `default`(component: ComponentType, state: Void) -> BuildType {
            BuildType(identifier: "default")
        }

        override func plugins(component: ComponentType) -> KeyValuePairs<String, AnyPlugin> {
            [
                "plugin1": AnyPlugin(BuildType(identifier: "plugin1")),
                "plugin2": AnyPlugin(BuildType(identifier: "plugin2")),
                "plugin3": AnyPlugin(BuildType(identifier: "plugin3"))
            ]
        }

        override func creationOrder(component: ComponentType) -> [String] {
            creationOrderOverride ?? super.creationOrder(component: component)
        }
    }

    func testPluginListCreateAll() {
        let pluginList: TestPluginList = .init { ComponentType() }
        expect(pluginList).to(notBeNilAndToDeallocateAfterTest())
        expect(pluginList.createAll().map(\.identifier)) == ["plugin1", "plugin2", "plugin3"]
        pluginList.creationOrderOverride = ["plugin3", "plugin1"]
        expect(pluginList.createAll().map(\.identifier)) == ["plugin3", "plugin1"]
        pluginList.creationOrderOverride = []
        expect(pluginList.createAll().map(\.identifier)) == []
    }

    func testPluginListWithDefaultCreateAll() {
        let pluginList: TestPluginListWithDefault = .init { ComponentType() }
        expect(pluginList).to(notBeNilAndToDeallocateAfterTest())
        expect(pluginList.createAll().map(\.identifier)) == ["default", "plugin1", "plugin2", "plugin3"]
        pluginList.creationOrderOverride = ["plugin3", "plugin1"]
        expect(pluginList.createAll().map(\.identifier)) == ["default", "plugin3", "plugin1"]
        pluginList.creationOrderOverride = []
        expect(pluginList.createAll().map(\.identifier)) == ["default"]
    }

    func testPluginListCreate() throws {
        let pluginList: TestPluginList = .init { ComponentType() }
        expect(pluginList).to(notBeNilAndToDeallocateAfterTest())
        expect(pluginList.create()?.identifier) == "plugin3"
        pluginList.creationOrderOverride = ["plugin3", "plugin1"]
        expect(pluginList.create()?.identifier) == "plugin1"
        pluginList.creationOrderOverride = []
        expect(pluginList.create()).to(beNil())
    }

    func testPluginListWithDefaultCreate() throws {
        let pluginList: TestPluginListWithDefault = .init { ComponentType() }
        expect(pluginList).to(notBeNilAndToDeallocateAfterTest())
        expect(pluginList.create()?.identifier) == "plugin3"
        pluginList.creationOrderOverride = ["plugin3", "plugin1"]
        expect(pluginList.create()?.identifier) == "plugin1"
        pluginList.creationOrderOverride = []
        expect(pluginList.create()?.identifier) == "default"
    }

    func testPluginListCreateWithKey() throws {
        let pluginList: TestPluginList = .init { ComponentType() }
        expect(pluginList).to(notBeNilAndToDeallocateAfterTest())
        expect(pluginList.create(key: "plugin2")?.identifier) == "plugin2"
        pluginList.creationOrderOverride = ["plugin3", "plugin1"]
        expect(pluginList.create(key: "plugin2")).to(beNil())
        pluginList.creationOrderOverride = []
        expect(pluginList.create(key: "plugin2")).to(beNil())
    }

    func testPluginListWithDefaultCreateWithKey() throws {
        let pluginList: TestPluginListWithDefault = .init { ComponentType() }
        expect(pluginList).to(notBeNilAndToDeallocateAfterTest())
        expect(pluginList.create(key: "plugin2")?.identifier) == "plugin2"
        pluginList.creationOrderOverride = ["plugin3", "plugin1"]
        expect(pluginList.create(key: "plugin2")?.identifier) == "default"
        pluginList.creationOrderOverride = []
        expect(pluginList.create(key: "plugin2")?.identifier) == "default"
    }

    func testPluginListDuplicateKeys() {
        let pluginList: TestPluginList = .init { ComponentType() }
        pluginList.creationOrderOverride = ["plugin1", "plugin1"]
        expect(pluginList.createAll()).to(throwAssertion())
    }

    func testPluginListWithDefaultDuplicateKeys() {
        let pluginList: TestPluginListWithDefault = .init { ComponentType() }
        pluginList.creationOrderOverride = ["plugin1", "plugin1"]
        expect(pluginList.createAll()).to(throwAssertion())
    }

    func testPluginListAssertions() {
        let component: ComponentType = .init()
        let pluginList: PluginList<String, ComponentType, BuildType, Void> = .init { component }
        expect(pluginList.creationOrder(component: component)).to(throwAssertion())
        expect(pluginList.plugins(component: component)).to(throwAssertion())
    }

    func testPluginListWithDefaultAssertions() {
        let component: ComponentType = .init()
        let pluginList: PluginListWithDefault<String, ComponentType, BuildType, Void> = .init { component }
        expect(pluginList.creationOrder(component: component)).to(throwAssertion())
        expect(pluginList.plugins(component: component)).to(throwAssertion())
    }
}
