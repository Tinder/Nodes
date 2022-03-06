//
//  PluginTests.swift
//  NodeTests
//
//  Created by Christopher Fuller on 5/4/21.
//

import Nimble
@testable import Nodes
import XCTest

final class PluginTests: XCTestCase, TestCaseHelpers {

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

    private var component: ComponentType!

    override func setUp() {
        super.setUp()
        tearDown(keyPath: \.component, initialValue: ComponentType())
    }

    override func tearDown() {
        super.tearDown()
    }

    func testCreate() {
        let plugin: TestPlugin = .init(component: component)
        expect(plugin).to(notBeNilAndToDeallocateAfterTest())
        expect(plugin.create()).to(beNil())
        plugin.isEnabledOverride = true
        expect(plugin.create()).to(beAKindOf(BuildType.self))
    }

    func testAssertions() {
        let component: ComponentType = .init()
        let plugin: Plugin<ComponentType, BuildType, Void> = .init(component: component)
        expect(plugin.isEnabled(component: component, state: ())).to(throwAssertion())
        expect(plugin.build(component: component)).to(throwAssertion())
    }
}
