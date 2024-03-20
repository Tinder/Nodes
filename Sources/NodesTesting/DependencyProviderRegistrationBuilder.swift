//
//  Copyright © 2023 Tinder (Match Group, LLC)
//

import NeedleFoundation

/**
 * A ``DependencyProviderRegistrationBuilder`` is used to inject Needle components descending from a scope.
 */
@MainActor
public final class DependencyProviderRegistrationBuilder {

    private var path: [String]
    private let registration: (_ path: [String], _ dependency: AnyObject) -> Void

    internal init(
        scope: Scope,
        registration: @escaping (_ path: [String], _ dependency: AnyObject) -> Void
    ) {
        self.path = scope.path
        self.registration = registration
    }

    /// Injects a Needle component with mock dependencies.
    ///
    /// - Parameters:
    ///   - type: A Needle component type.
    ///   - dependency: An auto-closure that returns a mocked dependency instance for the component.
    ///
    /// - Returns: The ``DependencyProviderRegistrationBuilder`` instance.
    @discardableResult
    public func injectComponent<T: Component<U>, U>(
        ofType type: T.Type,
        with dependency: @autoclosure () -> U
    ) -> Self {
        injectComponent(ofType: type, with: dependency)
    }

    /// Injects a Needle component with mock dependencies.
    ///
    /// - Parameters:
    ///   - type: A Needle component type.
    ///   - dependency: A closure that returns a mocked dependency instance for the component.
    ///
    /// - Returns: The ``DependencyProviderRegistrationBuilder`` instance.
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
