//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

import Nimble
import Nodes
import XCTest

final class PluginTests: XCTestCase, TestCaseHelpers {

    private class ComponentType {}

    private class BuildType {}

    private class TestPlugin: Plugin<ComponentType, BuildType, Void> {

        var isEnabledOverride: Bool = true

        // swiftlint:disable:next unused_parameter
        override func isEnabled(component: ComponentType, state: Void) -> Bool {
            isEnabledOverride
        }

        // swiftlint:disable:next unused_parameter
        override func build(component: ComponentType) -> BuildType {
            BuildType()
        }
    }

    private class AsyncTestPlugin: Plugin<ComponentType, BuildType, Void> {

        var isEnabledOverride: Bool = true

        // swiftlint:disable:next unused_parameter
        override func isEnabled(component: ComponentType, state: Void) -> Bool {
            isEnabledOverride
        }

        // swiftlint:disable:next unused_parameter async_without_await
        override func build(component: ComponentType) async -> BuildType {
            BuildType()
        }
    }

    @MainActor
    func testCreate() {
        let plugin: TestPlugin = .init { ComponentType() }
        expect(plugin).to(notBeNilAndToDeallocateAfterTest())
        expect(plugin.create()).to(beAKindOf(BuildType.self))
        plugin.isEnabledOverride = false
        expect(plugin.create()) == nil
    }

    @MainActor
    func testAsyncCreate() async {
        let plugin: AsyncTestPlugin = .init { ComponentType() }
        expect(plugin).to(notBeNilAndToDeallocateAfterTest())
        let result: BuildType? = await plugin.create()
        expect(result).to(beAKindOf(BuildType.self))
        plugin.isEnabledOverride = false
        let nilResult: BuildType? = await plugin.create()
        expect(nilResult) == nil
    }

    @MainActor
    func testOverride() {
        let plugin: TestPlugin = .init { ComponentType() }
        expect(plugin).to(notBeNilAndToDeallocateAfterTest())
        expect(plugin.override()).to(beAKindOf(BuildType.self))
    }

    @MainActor
    func testAsyncOverride() async {
        let plugin: AsyncTestPlugin = .init { ComponentType() }
        expect(plugin).to(notBeNilAndToDeallocateAfterTest())
        let result: BuildType = await plugin.override()
        expect(result).to(beAKindOf(BuildType.self))
    }

    @MainActor
    func testAssertions() {
        let component: ComponentType = .init()
        let plugin: Plugin<ComponentType, BuildType, Void> = .init { component }
        expect(plugin.isEnabled(component: component, state: ())).to(throwAssertion())
        expect(plugin.build(component: component)).to(throwAssertion())
    }

}
