//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

import NeedleFoundation
import XCTest

@MainActor
private let registry: __DependencyProviderRegistry = .instance

extension XCTestCase {

    /// Injects a Needle component with mock dependencies.
    ///
    /// - Parameters:
    ///   - componentFactory: A closure that initializes a Needle component instance.
    ///   - dependency: A closure that initializes a mocked dependency instance for the component.
    ///
    /// - Returns: A factory for the component using ``BootstrapComponent`` as the parent.
    @MainActor
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
    @MainActor
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
    @MainActor
    public func injectComponents(
        descendingFrom scope: () -> Scope
    ) -> DependencyProviderRegistrationBuilder {
        DependencyProviderRegistrationBuilder(scope: scope()) { [weak self] path, dependency in
            registry.register(path: path) { _ in
                dependency
            } onTeardown: { teardown in
                self?.addTeardownBlock(teardown)
            }
        }
    }

    @MainActor
    private func registerBootstrapComponent<T: Component<EmptyDependency>>(
        componentFactory: @escaping () -> T
    ) {
        let pathComponent: String = "\(PathComponent(for: T.self))"
        registry.register(path: ["^", pathComponent]) { scope in
            EmptyDependencyProvider(component: scope)
        } onTeardown: { teardown in
            addTeardownBlock(teardown)
        }
    }
}
