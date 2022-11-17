//
//  DefaultsAppKit.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/15/22.
//

extension UIFramework {

    internal final class DefaultsAppKit {

        private let viewControllerSuperParameters: String = "nibName: nil, bundle: nil"
        private let viewControllerProperties: String = ""

        private let viewControllerMethods: String = """
            override func viewWillAppear() {
                super.viewWillAppear()
                observe(viewState).store(in: &cancellables)
            }

            override func viewWillDisappear() {
                super.viewWillDisappear()
                cancellables.removeAll()
            }
            """

        private let viewControllerMethodsForRootNode: String = """
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
