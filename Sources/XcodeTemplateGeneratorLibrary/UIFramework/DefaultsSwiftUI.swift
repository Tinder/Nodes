//
//  DefaultsSwiftUI.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/15/22.
//

extension UIFramework {

    internal final class DefaultsSwiftUI {

        private let viewControllerSuperParameters: String = ""
        private let viewControllerProperties: String = ""
        private let viewControllerMethods: String = ""

        private let viewControllerMethodsForRootNode: String = """
            override func viewDidAppear(_ animated: Bool) {
                super.viewDidAppear(animated)
                receiver?.viewDidAppear()
            }
            """

        internal func makeUIFramework() -> UIFramework {
            UIFramework(
                framework: .swiftUI,
                viewControllerSuperParameters: viewControllerSuperParameters,
                viewControllerProperties: viewControllerProperties,
                viewControllerMethods: viewControllerMethods,
                viewControllerMethodsForRootNode: viewControllerMethodsForRootNode
            )
        }
    }
}
