//
//  DefaultAppKitFramework.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/15/22.
//

extension UIFramework {

    internal enum DefaultAppKitFramework {

        private static var viewControllerSuperParameters: String { "nibName: nil, bundle: nil" }
        private static var viewControllerProperties: String { "" }

        private static var viewControllerMethods: String {
            """
            override func viewWillAppear() {
                super.viewWillAppear()
                observe(viewState).store(in: &cancellables)
            }

            override func viewWillDisappear() {
                super.viewWillDisappear()
                cancellables.removeAll()
            }
            """
        }

        private static var viewControllerMethodsForRootNode: String {
            """
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

        internal static func make() -> UIFramework {
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
