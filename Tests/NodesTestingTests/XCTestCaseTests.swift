//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

import NeedleFoundation
import Nimble
import NodesTesting
import XCTest

final class XCTestCaseTests: XCTestCase {

    private class ParentDependency: Dependency {}
    private class ChildDependency: Dependency {}

    private class ParentComponent: Component<ParentDependency> {}
    private class ChildComponent: Component<ChildDependency> {}

    @MainActor
    private static let registry: __DependencyProviderRegistry = .instance

    private static let parentPath: String = "^->BootstrapComponent->ParentComponent"
    private static let childPath: String = "^->BootstrapComponent->ParentComponent->ChildComponent"

    @MainActor
    override func setUp() {
        super.setUp()
        expect(Self.registry.dependencyProviderFactory(for: Self.parentPath)) == nil
        expect(Self.registry.dependencyProviderFactory(for: Self.childPath)) == nil
    }

    @MainActor
    override func tearDown() {
        expect(Self.registry.dependencyProviderFactory(for: Self.parentPath)) == nil
        expect(Self.registry.dependencyProviderFactory(for: Self.childPath)) == nil
        super.tearDown()
    }

    @MainActor
    func testInjectComponents() throws {

        // GIVEN

        let childDependencyA: ChildDependency = .init()
        let childDependencyB: ChildDependency = .init()

        // WHEN

        let parentComponentFactory: () -> ParentComponent = injectComponent { scope in
            ParentComponent(parent: scope)
        } with: {
            ParentDependency()
        }

        // THEN

        expect(Self.registry.dependencyProviderFactory(for: Self.parentPath)) != nil

        // WHEN

        let parentComponent: ParentComponent = parentComponentFactory()

        // THEN

        expect(parentComponent.path.joined(separator: "->")) == Self.parentPath

        // WHEN

        injectComponents(descendingFrom: parentComponent)
            .injectComponent(ofType: ChildComponent.self, with: childDependencyA)

        // THEN

        let childDependencyFactoryA: ((Scope) -> AnyObject) = try dependencyProviderFactory(path: Self.childPath)
        expect(childDependencyFactoryA(parentComponent)) === childDependencyA as AnyObject

        // WHEN

        injectComponents(descendingFrom: parentComponent)
            .injectComponent(ofType: ChildComponent.self, with: childDependencyB)

        // THEN

        let childDependencyFactoryB: ((Scope) -> AnyObject) = try dependencyProviderFactory(path: Self.childPath)
        expect(childDependencyFactoryB(parentComponent)) === childDependencyB as AnyObject
    }

    @MainActor
    private func dependencyProviderFactory(
        path: String
    ) throws -> (Scope) -> AnyObject {
        try XCTUnwrap(Self.registry.dependencyProviderFactory(for: path))
    }
}
