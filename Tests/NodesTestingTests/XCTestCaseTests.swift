//
//  XCTestCaseTests.swift
//  NodesTestingTests
//
//  Created by Eman Haroutunian on 1/11/23.
//

import NeedleFoundation
import Nimble
@testable import NodesTesting
import XCTest

final class XCTestCaseTests: XCTestCase {

    private class ParentDependency: Dependency {}
    private class ChildDependency: Dependency {}

    private class ParentComponent: Component<ParentDependency> {}
    private class ChildComponent: Component<ChildDependency> {}

    private static let registry: __DependencyProviderRegistry = .instance
    private static let parentPath: String = "^->BootstrapComponent->ParentComponent"
    private static let childPath: String = "^->BootstrapComponent->ParentComponent->ChildComponent"

    override func setUp() {
        super.setUp()
        expect(Self.registry.dependencyProviderFactory(for: Self.parentPath)).to(beNil())
        expect(Self.registry.dependencyProviderFactory(for: Self.childPath)).to(beNil())
    }

    override func tearDown() {
        expect(Self.registry.dependencyProviderFactory(for: Self.parentPath)).to(beNil())
        expect(Self.registry.dependencyProviderFactory(for: Self.childPath)).to(beNil())
        super.tearDown()
    }

    func testInjectComponents() throws {
        // Given
        let childDependencyA: ChildDependency = .init()
        let childDependencyB: ChildDependency = .init()

        // Then
        expect(Self.registry.dependencyProviderFactory(for: Self.parentPath)).to(beNil())
        expect(Self.registry.dependencyProviderFactory(for: Self.childPath)).to(beNil())

        // When
        let parentComponentFactory: () -> ParentComponent = injectComponent {
            ParentComponent(parent: $0)
        } with: {
            ParentDependency()
        }

        // Then
        expect(Self.registry.dependencyProviderFactory(for: Self.parentPath)).toNot(beNil())

        // When
        let parentComponent: ParentComponent = parentComponentFactory()

        // Then
        expect(parentComponent.path.joined(separator: "->")) == Self.parentPath

        // When
        injectComponents(descendingFrom: parentComponent)
            .injectComponent(ofType: ChildComponent.self, with: childDependencyA)

        // Then
        let childDependencyFactoryA: ((Scope) -> AnyObject) = try dependencyProviderFactory(path: Self.childPath)
        expect(childDependencyFactoryA(parentComponent)) === childDependencyA as AnyObject

        // When
        injectComponents(descendingFrom: parentComponent)
            .injectComponent(ofType: ChildComponent.self, with: childDependencyB)

        // Then
        let childDependencyFactoryB: ((Scope) -> AnyObject) = try dependencyProviderFactory(path: Self.childPath)
        expect(childDependencyFactoryB(parentComponent)) === childDependencyB as AnyObject

    }

    private func dependencyProviderFactory(
        path: String
    ) throws -> (Scope) -> AnyObject {
        try XCTUnwrap(Self.registry.dependencyProviderFactory(for: path))
    }
}
