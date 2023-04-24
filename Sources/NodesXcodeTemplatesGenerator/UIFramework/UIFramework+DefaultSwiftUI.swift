//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

extension UIFramework {

    internal static func makeDefaultSwiftUIFramework() -> UIFramework {
        UIFramework(
            framework: .swiftUI,
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
