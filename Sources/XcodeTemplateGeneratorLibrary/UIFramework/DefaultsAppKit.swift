//
//  DefaultsAppKit.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/15/22.
//

extension UIFramework {

    internal final class DefaultsAppKit {

        private let viewControllerSuperParameters: String = ""
        private let viewControllerProperties: String = ""
        private let viewControllerMethods: String = ""
        private let viewControllerMethodsForRootNode: String = ""

        internal func makeUIFramework() -> UIFramework {
            UIFramework(
                framework: .appKit,
                viewControllerSuperParameters: viewControllerSuperParameters,
                viewControllerProperties: viewControllerProperties,
                viewControllerMethods: viewControllerMethods,
                viewControllerMethodsForRootNode: viewControllerMethodsForRootNode
            )
        }
    }
}
