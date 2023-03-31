//
//  UIFramework+Default.swift
//  NodesXcodeTemplatesGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/15/22.
//

extension UIFramework {

    internal static func makeDefaultFramework(for framework: UIFramework.Framework) -> UIFramework {
        UIFramework(
            framework: framework,
            viewControllerProperties: "",
            viewControllerMethods: "",
            viewControllerMethodsForRootNode: ""
        )
    }
}
