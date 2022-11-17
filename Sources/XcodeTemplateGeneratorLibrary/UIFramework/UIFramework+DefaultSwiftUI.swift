//
//  UIFramework+DefaultSwiftUI.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/15/22.
//

extension UIFramework {

    internal static func makeDefaultSwiftUIFramework() -> UIFramework {
        UIFramework(
            framework: .swiftUI,
            viewControllerSuperParameters: "",
            viewControllerProperties: "",
            viewControllerMethods: "",
            viewControllerMethodsForRootNode: """
                override func viewDidAppear(_ animated: Bool) {
                    super.viewDidAppear(animated)
                    receiver?.viewDidAppear()
                }
                """
        )
    }
}
