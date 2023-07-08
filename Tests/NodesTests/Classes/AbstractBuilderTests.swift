//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Nimble
@testable import Nodes
import XCTest

@MainActor
final class AbstractBuilderTests: XCTestCase {

    private class ComponentType {}

    private class BuildType {}

    private class TestBuilder: AbstractBuilder<ComponentType, BuildType, Void, Void> {

        override func build(component: ComponentType, dynamicBuildDependency: Void) -> BuildType {
            BuildType()
        }
    }

    func testBuild() {
        let builder: TestBuilder = givenBuilder { ComponentType() }
        expect(builder.build()).to(beAKindOf(BuildType.self))
    }

    func testAssertions() {
        let builder: AbstractBuilder<ComponentType, BuildType, Void, Void> = .init { ComponentType() }
        expect(builder.build()).to(throwAssertion()) // precondition failure for non-overridden method
        expect(builder.build()).to(throwAssertion()) // assertion failure for re-used component instance
    }

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
