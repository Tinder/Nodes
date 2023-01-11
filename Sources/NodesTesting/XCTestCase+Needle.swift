//
//  Created by Christopher Fuller on 6/2/22.
//  Copyright © 2020 Tinder. All rights reserved.
//

import NeedleFoundation
import Nodes
import XCTest

private let registry: __DependencyProviderRegistry = .instance

extension XCTestCase {

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

    public func injectComponents(
        descendingFrom scope: @autoclosure () -> Scope
    ) -> DependencyProviderRegistrationBuilder {
        injectComponents(descendingFrom: scope)
    }

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

    @discardableResult
    public func injectComponent<T: Component<U>, U>(
        ofType type: T.Type,
        with dependency: @autoclosure () -> U
    ) -> Self {
        injectComponent(ofType: type, with: dependency)
    }

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
