//
//  Defaults.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/15/22.
//

extension UIFramework {

    internal enum DefaultFramework {

        private static var viewControllerSuperParameters: String { "" }
        private static var viewControllerProperties: String { "" }
        private static var viewControllerMethods: String { "" }
        private static var viewControllerMethodsForRootNode: String { "" }

        internal static func make(for framework: UIFramework.Framework) -> UIFramework {
            UIFramework(
                framework: framework,
                viewControllerSuperParameters: viewControllerSuperParameters,
                viewControllerProperties: viewControllerProperties,
                viewControllerMethods: viewControllerMethods,
                viewControllerMethodsForRootNode: viewControllerMethodsForRootNode
            )
        }
    }
}
