//
//  PluginMapTests.swift
//  NodeTests
//
//  Created by Christopher Fuller on 5/4/21.
//

import Nimble
@testable import Nodes
import XCTest

final class PluginMapTests: XCTestCase, TestCaseHelpers {

    private class ComponentType {}

    private class BuildType {}

    private class TestPlugin: Plugin<ComponentType, BuildType, Void> {

        // swiftlint:disable:next redundant_type_annotation
        var isEnabledOverride: Bool = false

        override func isEnabled(component: ComponentType, state: Void) -> Bool {
            isEnabledOverride
        }

        override func build(component: ComponentType) -> BuildType {
            BuildType()
        }
    }

    private class TestPluginMap: PluginMap<String, ComponentType, BuildType, Void> {

        // swiftlint:disable:next redundant_type_annotation
        var isEnabledOverride: Bool = false

        override func plugins(component: ComponentType) -> [String: Plugin] {
            let plugin: TestPlugin = .init(component: component)
            plugin.isEnabledOverride = isEnabledOverride
            return [
                "key1": Plugin(plugin.create()),
                "key2": Plugin(plugin.create()),
                "key3": Plugin(plugin.create())
            ]
        }
    }

    private class TestPluginMapWithDefault: PluginMapWithDefault<String, ComponentType, BuildType, Void> {

        // swiftlint:disable:next redundant_type_annotation
        var isEnabledOverride: Bool = false

        override func `default`(component: ComponentType, state: Void) -> BuildType {
            BuildType()
        }

        override func plugins(component: ComponentType) -> [String: Plugin] {
            let plugin: TestPlugin = .init(component: component)
            plugin.isEnabledOverride = isEnabledOverride
            return [
                "key1": Plugin(plugin.create()),
                "key2": Plugin(plugin.create()),
                "key3": Plugin(plugin.create())
            ]
        }
    }

    private var component: ComponentType!

    override func setUp() {
        super.setUp()
        tearDown(keyPath: \.component, initialValue: ComponentType())
    }

    func testCreateAll() {
        let pluginMap: TestPluginMap = .init(component: component)
        expect(pluginMap).to(notBeNilAndToDeallocateAfterTest())
        expect(pluginMap.createAll()).to(beEmpty())
        pluginMap.isEnabledOverride = true
        expect(pluginMap.createAll()).to(haveCount(3))
    }

    func testCreate() {
        let pluginMap: TestPluginMap = .init(component: component)
        expect(pluginMap).to(notBeNilAndToDeallocateAfterTest())
        expect(pluginMap.create(key: "key1")).to(beNil())
        pluginMap.isEnabledOverride = true
        expect(pluginMap.create(key: "key1")).to(beAKindOf(BuildType.self))
    }

    func testCreateAllWithDefault() {
        let pluginMap: TestPluginMapWithDefault = .init(component: component)
        expect(pluginMap).to(notBeNilAndToDeallocateAfterTest())
        expect(pluginMap.createAll()).to(haveCount(1))
        pluginMap.isEnabledOverride = true
        expect(pluginMap.createAll()).to(haveCount(4))
    }

    func testCreateWithDefault() {
        let pluginMap: TestPluginMapWithDefault = .init(component: component)
        expect(pluginMap).to(notBeNilAndToDeallocateAfterTest())
        expect(pluginMap.create(key: "key1") as BuildType).to(beAKindOf(BuildType.self))
        pluginMap.isEnabledOverride = true
        expect(pluginMap.create(key: "key1")).to(beAKindOf(BuildType.self))
    }

    func testAssertions() {
        let component: ComponentType = .init()
        let pluginMap: PluginMapWithDefault<String, ComponentType, BuildType, Void> = .init(component: component)
        expect(pluginMap.plugins(component: component)).to(throwAssertion())
        expect(pluginMap.default(component: component, state: ())).to(throwAssertion())
    }
}
