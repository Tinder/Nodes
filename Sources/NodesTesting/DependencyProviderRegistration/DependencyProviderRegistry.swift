// swiftlint:disable:this file_name
//
//  Copyright © 2023 Tinder (Match Group, LLC)
//

import NeedleFoundation

extension __DependencyProviderRegistry {

    @MainActor
    internal func register(
        path: [String],
        dependencyProviderFactory dependency: @escaping (_ scope: Scope) -> AnyObject,
        onTeardown: (@MainActor @Sendable @escaping () -> Void) -> Void
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
