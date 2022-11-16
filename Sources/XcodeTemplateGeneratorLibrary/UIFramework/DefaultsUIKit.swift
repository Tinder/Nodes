//
//  DefaultsUIKit.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/15/22.
//

extension UIFramework {

    internal final class DefaultsUIKit {

        private let viewControllerSuperParameters: String = "nibName: nil, bundle: nil"
        private let viewControllerProperties: String = ""

        private let viewControllerMethods: String = """
            override func viewDidLoad() {
                super.viewDidLoad()
                view.backgroundColor = .systemBackground
            }

            override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
                observe(viewState).store(in: &cancellables)
            }

            override func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)
                cancellables.removeAll()
            }
            """

        private let viewControllerMethodsForRootNode: String = """
            override func viewDidLoad() {
                super.viewDidLoad()
                view.backgroundColor = .systemBackground
            }

            override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
                observe(viewState).store(in: &cancellables)
            }

            override func viewDidAppear(_ animated: Bool) {
                super.viewDidAppear(animated)
                receiver?.viewDidAppear()
            }

            override func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)
                cancellables.removeAll()
            }
            """

        internal func makeUIFramework() -> UIFramework {
            UIFramework(
                framework: .uiKit,
                viewControllerSuperParameters: viewControllerSuperParameters,
                viewControllerProperties: viewControllerProperties,
                viewControllerMethods: viewControllerMethods,
                viewControllerMethodsForRootNode: viewControllerMethodsForRootNode
            )
        }
    }
}
