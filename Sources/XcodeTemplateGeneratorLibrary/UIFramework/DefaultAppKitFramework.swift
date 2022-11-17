//
//  DefaultAppKitFramework.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/15/22.
//

extension UIFramework {

    private struct Defaults {

        let viewControllerSuperParameters: String = "nibName: nil, bundle: nil"
        let viewControllerProperties: String = ""

        let viewControllerMethods: String = """
            override func viewWillAppear() {
                super.viewWillAppear()
                observe(viewState).store(in: &cancellables)
            }

            override func viewWillDisappear() {
                super.viewWillDisappear()
                cancellables.removeAll()
            }
            """

        let viewControllerMethodsForRootNode: String = """
            override func viewWillAppear() {
                super.viewWillAppear()
                observe(viewState).store(in: &cancellables)
            }

            override func viewDidAppear() {
                super.viewDidAppear()
                receiver?.viewDidAppear()
            }

            override func viewWillDisappear() {
                super.viewWillDisappear()
                cancellables.removeAll()
            }
            """
    }

    internal static func makeDefaultAppKitFramework() -> UIFramework {
        let defaults: Defaults = .init()
        return UIFramework(
            framework: .appKit,
            viewControllerSuperParameters: defaults.viewControllerSuperParameters,
            viewControllerProperties: defaults.viewControllerProperties,
            viewControllerMethods: defaults.viewControllerMethods,
            viewControllerMethodsForRootNode: defaults.viewControllerMethodsForRootNode
        )
    }
}
