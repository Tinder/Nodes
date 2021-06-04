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

    private class TestPluginList: PluginList<ComponentType, BuildType, Void> {

        // swiftlint:disable:next redundant_type_annotation
        var isEnabledOverride: Bool = false

        override func plugins(component: ComponentType) -> [Plugin] {
            let plugin: TestPlugin = .init(component: component)
            plugin.isEnabledOverride = isEnabledOverride
            return [Plugin(plugin.create()), Plugin(plugin.create()), Plugin(plugin.create())]
        }
    }

    private class TestPluginListWithDefault: PluginListWithDefault<ComponentType, BuildType, Void> {

        // swiftlint:disable:next redundant_type_annotation
        var isEnabledOverride: Bool = false

        override func `default`(component: ComponentType, state: Void) -> BuildType {
            BuildType()
        }

        override func plugins(component: ComponentType) -> [Plugin] {
            let plugin: TestPlugin = .init(component: component)
            plugin.isEnabledOverride = isEnabledOverride
            return [Plugin(plugin.create()), Plugin(plugin.create()), Plugin(plugin.create())]
        }
    }

    private var component: ComponentType!

    override func setUp() {
        super.setUp()
        tearDown(keyPath: \.component, initialValue: ComponentType())
    }

    func testCreateAll() {
        let pluginList: TestPluginList = .init(component: component)
        expect(pluginList).to(notBeNilAndToDeallocateAfterTest())
        expect(pluginList.createAll()).to(beEmpty())
        pluginList.isEnabledOverride = true
        expect(pluginList.createAll()).to(haveCount(3))
    }

    func testCreate() {
        let pluginList: TestPluginList = .init(component: component)
        expect(pluginList).to(notBeNilAndToDeallocateAfterTest())
        expect(pluginList.create()).to(beNil())
        pluginList.isEnabledOverride = true
        expect(pluginList.create()).to(beAKindOf(BuildType.self))
    }

    func testCreateAllWithDefault() {
        let pluginList: TestPluginListWithDefault = .init(component: component)
        expect(pluginList).to(notBeNilAndToDeallocateAfterTest())
        expect(pluginList.createAll()).to(haveCount(1))
        pluginList.isEnabledOverride = true
        expect(pluginList.createAll()).to(haveCount(4))
    }

    func testCreateWithDefault() {
        let pluginList: TestPluginListWithDefault = .init(component: component)
        expect(pluginList).to(notBeNilAndToDeallocateAfterTest())
        expect(pluginList.create() as BuildType).to(beAKindOf(BuildType.self))
        pluginList.isEnabledOverride = true
        expect(pluginList.create()).to(beAKindOf(BuildType.self))
    }

    func testAssertions() {
        let component: ComponentType = .init()
        let pluginList: PluginListWithDefault<ComponentType, BuildType, Void> = .init(component: component)
        expect(pluginList.plugins(component: component)).to(throwAssertion())
        expect(pluginList.default(component: component, state: ())).to(throwAssertion())
    }
}
