//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

extension UIFramework {

    internal static func makeDefaultFramework(for framework: UIFramework.Framework) -> UIFramework {
        UIFramework(
            framework: framework,
            viewControllerProperties: "",
            viewControllerMethods: ""
        )
    }
}
