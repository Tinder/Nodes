//
//  Defaults.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/15/22.
//

extension UIFramework {

    internal final class Defaults {

        private let viewControllerSuperParameters: String = ""
        private let viewControllerProperties: String = ""
        private let viewControllerMethods: String = ""
        private let viewControllerMethodsForRootNode: String = ""

        internal func makeUIFramework(for framework: UIFramework.Framework) -> UIFramework {
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
