//
//  UIFramework+DefaultUIKit.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/15/22.
//

extension UIFramework {

    private enum Defaults {

        static let viewControllerMethods: String = """
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

        static let viewControllerMethodsForRootNode: String = """
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
    }

    internal static func makeDefaultUIKitFramework() -> UIFramework {
        UIFramework(
            framework: .uiKit,
            viewControllerProperties: "",
            viewControllerMethods: Defaults.viewControllerMethods,
            viewControllerMethodsForRootNode: Defaults.viewControllerMethodsForRootNode
        )
    }
}
