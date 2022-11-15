//
//  UIFrameworkDefaults.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/15/22.
//

internal protocol UIFrameworkDefaults {

    var viewControllerSuperParameters: String { get }
    var viewControllerProperties: String { get }
    var viewControllerMethods: String { get }
    var viewControllerMethodsForRootNode: String { get }
}

internal struct UIFrameworkAppKitDefaults: UIFrameworkDefaults {

    internal let viewControllerSuperParameters: String = ""
    internal let viewControllerProperties: String = ""
    internal let viewControllerMethods: String = ""
    internal let viewControllerMethodsForRootNode: String = ""
}

internal struct UIFrameworkUIKitDefaults: UIFrameworkDefaults {

    internal let viewControllerSuperParameters: String = "nibName: nil, bundle: nil"
    internal let viewControllerProperties: String = ""
    internal let viewControllerMethods: String = """
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
    internal let viewControllerMethodsForRootNode: String = """
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

internal struct UIFrameworkSwiftUIDefaults: UIFrameworkDefaults {

    internal let viewControllerSuperParameters: String = ""
    internal let viewControllerProperties: String = ""
    internal let viewControllerMethods: String = ""
    internal let viewControllerMethodsForRootNode: String = """
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            receiver?.viewDidAppear()
        }
        """
}

internal struct UIFrameworkCustomDefaults: UIFrameworkDefaults {

    internal let viewControllerSuperParameters: String = ""
    internal let viewControllerProperties: String = ""
    internal let viewControllerMethods: String = ""
    internal let viewControllerMethodsForRootNode: String = ""
}
