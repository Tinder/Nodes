//
//  File.swift
//  
//
//  Created by Garric Nahapetian on 11/10/22.
//

public extension UIFramework {

    struct Options: Equatable, Decodable, Encodable {

        public var viewControllerMethods: String
        public var viewControllerMethodsForRootNode: String
        public var viewControllerProperties: String
        public var viewControllerSuperParameters: String

        public init(
            viewControllerMethods: String,
            viewControllerMethodsForRootNode: String,
            viewControllerProperties: String,
            viewControllerSuperParameters: String
        ) {
            self.viewControllerMethods = viewControllerMethods
            self.viewControllerMethodsForRootNode = viewControllerMethodsForRootNode
            self.viewControllerProperties = viewControllerProperties
            self.viewControllerSuperParameters = viewControllerSuperParameters
        }
    }
}

public extension UIFramework.Options {

    static let appKitDefaultOptions: UIFramework.Options = .init(
        viewControllerMethods: """
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
            """,
        viewControllerMethodsForRootNode: """
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
            """,
        viewControllerProperties: "",
        viewControllerSuperParameters: "nibName: nil, bundle: nil"
    )

    static let uiKitDefaultOptions: UIFramework.Options = .init(
        viewControllerMethods: """
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
            """,
        viewControllerMethodsForRootNode: """
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
            """,
        viewControllerProperties: "",
        viewControllerSuperParameters: "nibName: nil, bundle: nil"
    )

    static let swiftUIDefaultOptions: UIFramework.Options = .init(
        viewControllerMethods: "",
        viewControllerMethodsForRootNode: """
            override func viewDidAppear(_ animated: Bool) {
                super.viewDidAppear(animated)
                receiver?.viewDidAppear()
            }
            """,
        viewControllerProperties: "",
        viewControllerSuperParameters: ""
    )
}
