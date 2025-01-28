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

final class AbstractBuilderTests: XCTestCase {

    private class ComponentType {}

    private class BuildType {}

    private class TestBuilder: AbstractBuilder<ComponentType, BuildType, Void, Void> {

        // swiftlint:disable:next unused_parameter
        override func build(component: ComponentType, dynamicBuildDependency: Void) -> BuildType {
            BuildType()
        }
    }

    @MainActor
    func testBuild() {
        let builder: TestBuilder = givenBuilder { ComponentType() }
        expect(builder.build()).to(beAKindOf(BuildType.self))
    }

    @MainActor
    func testAssertions() {
        let builder: AbstractBuilder<ComponentType, BuildType, Void, Void> = .init { ComponentType() }
        expect(builder.build()).to(throwAssertion()) // precondition failure for non-overridden method
        expect(builder.build()).to(throwAssertion()) // assertion failure for re-used component instance
    }

    @MainActor
    private func givenBuilder(componentFactory: @escaping () -> ComponentType) -> TestBuilder {
        let builder: TestBuilder = .init(componentFactory: componentFactory)
        expect(builder).to(notBeNilAndToDeallocateAfterTest())
        return builder
    }
}

extension AbstractBuilder where DynamicBuildDependencyType == Void, DynamicComponentDependencyType == Void {

    func build() -> BuildType {
        build((), ())
    }
}
