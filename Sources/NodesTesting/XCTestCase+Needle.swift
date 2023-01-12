//
//  Created by Christopher Fuller on 6/2/22.
//  Copyright © 2020 Tinder. All rights reserved.
//

import NeedleFoundation
import Nodes
import XCTest

private let registry: __DependencyProviderRegistry = .instance

extension XCTestCase {

    /// Injects a Needle component with mock dependencies.
    ///
    /// - Parameters:
    ///   - componentFactory: A closure that initializes a Needle component instance.
    ///   - dependency: A closure that initializes a mocked dependency instance for the component.
    ///
    /// - Returns: The provided component factory.
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

    /// Creates a DependencyProviderRegistrationBuilder with a given scope.
    ///
    /// - Parameter scope: The scope in which components will be injected.
    ///
    /// - Returns: The `DependencyProviderRegistrationBuilder` instance.
    public func injectComponents(
        descendingFrom scope: @autoclosure () -> Scope
    ) -> DependencyProviderRegistrationBuilder {
        injectComponents(descendingFrom: scope)
    }

    /// Creates a DependencyProviderRegistrationBuilder with a given scope.
    ///
    /// - Parameter scope: The scope in which components will be injected.
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

/// Responsible for adding dependencies to a dependence graph.
public final class DependencyProviderRegistrationBuilder {

    private var path: [String]
    private let registration: (_ path: [String], _ dependency: AnyObject) -> Void

    fileprivate init(
        scope: Scope,
        registration: @escaping (_ path: [String], _ dependency: AnyObject) -> Void
    ) {
        self.path = scope.path
        self.registration = registration
    }

    /// Injects a component into the scope.
    ///
    /// - Parameters:
    ///   - type: The component's type.
    ///   - dependency: An auto-closure that returns the desired dependency.
    ///
    /// - Returns: The `DependencyProviderRegistrationBuilder` instance.
    @discardableResult
    public func injectComponent<T: Component<U>, U>(
        ofType type: T.Type,
        with dependency: @autoclosure () -> U
    ) -> Self {
        injectComponent(ofType: type, with: dependency)
    }

    /// Injects a component into the scope.
    ///
    /// - Parameters:
    ///   - type: The component's type.
    ///   - dependency: A closure that returns the desired dependency.
    ///
    /// - Returns: The `DependencyProviderRegistrationBuilder` instance.
    @discardableResult
    public func injectComponent<T: Component<U>, U>(
        ofType type: T.Type,
        with dependency: () -> U
    ) -> Self {
        let pathComponent: String = "\(PathComponent(for: T.self))"
        path.append(pathComponent)
        registration(path, dependency() as AnyObject)
        return self
    }
}

private extension __DependencyProviderRegistry {

    func register(
        path: [String],
        dependencyProviderFactory dependency: @escaping (_ scope: Scope) -> AnyObject,
        onTeardown: (@escaping () -> Void) -> Void
    ) {
        let componentPath: String = path.joined(separator: "->")
        if dependencyProviderFactory(for: componentPath) != nil {
            unregisterDependencyProviderFactory(for: componentPath)
        } else {
            onTeardown { [weak self] in
                self?.unregisterDependencyProviderFactory(for: componentPath)
            }
        }
        registerDependencyProviderFactory(for: componentPath, dependency)
    }
}

private class PathComponent: CustomStringConvertible {

    let description: String

    init<T>(for type: T.Type) {
        description = "\(T.self)"
            .components(separatedBy: ".")
            .reversed()[0]
    }
}
