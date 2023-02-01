//
//  XCTestCase.swift
//
//
//  Created by Christopher Fuller on 6/2/22.
//

import NeedleFoundation
import XCTest

private let registry: __DependencyProviderRegistry = .instance

extension XCTestCase {

    /// Injects a Needle component with mock dependencies.
    ///
    /// - Parameters:
    ///   - componentFactory: A closure that initializes a Needle component instance.
    ///   - dependency: A closure that initializes a mocked dependency instance for the component.
    ///
    /// - Returns: A factory for the component using ``BootstrapComponent`` as the parent.
    public func injectComponent<T: Component<U>, U>(
        componentFactory: @escaping (_ parent: Scope) -> T,
        with dependency: () -> U
    ) -> () -> T {
        let bootstrap: () -> BootstrapComponent = { BootstrapComponent() }
        registerBootstrapComponent(componentFactory: bootstrap)
        injectComponents(descendingFrom: bootstrap)
            .injectComponent(ofType: T.self, with: dependency)
        return { componentFactory(bootstrap()) }
    }

    /// Creates a ``DependencyProviderRegistrationBuilder`` instance with a given scope.
    ///
    /// - Parameter scope: The scope from which injected components will descend.
    ///
    /// - Returns: The `DependencyProviderRegistrationBuilder` instance.
    public func injectComponents(
        descendingFrom scope: @autoclosure () -> Scope
    ) -> DependencyProviderRegistrationBuilder {
        injectComponents(descendingFrom: scope)
    }

    /// Creates a ``DependencyProviderRegistrationBuilder`` instance with a given scope.
    ///
    /// - Parameter scope: The scope from which injected components will descend.
    ///
    /// - Returns: The `DependencyProviderRegistrationBuilder` instance.
    public func injectComponents(
        descendingFrom scope: () -> Scope
    ) -> DependencyProviderRegistrationBuilder {
        DependencyProviderRegistrationBuilder(scope: scope()) { [weak self] path, dependency in
            // swiftlint:disable:next multiline_arguments
            registry.register(path: path) { _ in
                dependency
            } onTeardown: {
                self?.addTeardownBlock($0)
            }
        }
    }

    private func registerBootstrapComponent<T: Component<EmptyDependency>>(
        componentFactory: @escaping () -> T
    ) {
        let pathComponent: String = "\(PathComponent(for: T.self))"
        // swiftlint:disable:next multiline_arguments
        registry.register(path: ["^", pathComponent]) {
            EmptyDependencyProvider(component: $0)
        } onTeardown: {
            addTeardownBlock($0)
        }
    }
}
