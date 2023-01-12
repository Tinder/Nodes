//
//  DependencyProviderRegistrationBuilder.swift
//  
//
//  Created by Eman Haroutunian on 1/12/23.
//

import NeedleFoundation

/// Responsible for adding dependencies to a dependence graph.
public final class DependencyProviderRegistrationBuilder {

    private var path: [String]
    private let registration: (_ path: [String], _ dependency: AnyObject) -> Void

    init(
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
