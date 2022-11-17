//
//  DefaultFramework.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/15/22.
//

extension UIFramework {

    internal enum DefaultFramework {

        internal static func make(for framework: UIFramework.Framework) -> UIFramework {
            UIFramework(
                framework: framework,
                viewControllerSuperParameters: "",
                viewControllerProperties: "",
                viewControllerMethods: "",
                viewControllerMethodsForRootNode: ""
            )
        }
    }
}
