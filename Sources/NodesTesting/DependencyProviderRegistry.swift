// swiftlint:disable:this file_name
//
//  DependencyProviderRegistry.swift
//  NodesTesting
//
//  Created by Eman Haroutunian on 1/12/23.
//

import NeedleFoundation

extension __DependencyProviderRegistry {

    internal func register(
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
