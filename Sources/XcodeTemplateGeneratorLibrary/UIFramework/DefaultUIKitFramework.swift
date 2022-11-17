//
//  DefaultUIKitFramework.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/15/22.
//

extension UIFramework {

    private struct Defaults {

        let viewControllerSuperParameters: String = "nibName: nil, bundle: nil"
        let viewControllerProperties: String = ""

        let viewControllerMethods: String = """
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

        let viewControllerMethodsForRootNode: String = """
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
        let defaults: Defaults = .init()
        return UIFramework(
            framework: .uiKit,
            viewControllerSuperParameters: defaults.viewControllerSuperParameters,
            viewControllerProperties: defaults.viewControllerProperties,
            viewControllerMethods: defaults.viewControllerMethods,
            viewControllerMethodsForRootNode: defaults.viewControllerMethodsForRootNode
        )
    }
}
