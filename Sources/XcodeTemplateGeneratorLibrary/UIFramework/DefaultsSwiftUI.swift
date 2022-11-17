//
//  DefaultsSwiftUI.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/15/22.
//

extension UIFramework {

    internal enum DefaultSwiftUIFramework {

        private static var viewControllerSuperParameters: String { "" }
        private static var viewControllerProperties: String { "" }
        private static var viewControllerMethods: String { "" }

        private static var viewControllerMethodsForRootNode: String {
            """
            override func viewDidAppear(_ animated: Bool) {
                super.viewDidAppear(animated)
                receiver?.viewDidAppear()
            }
            """
        }

        internal static func make() -> UIFramework {
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
