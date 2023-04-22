//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

extension UIFramework {

    private enum Defaults {

        static let viewControllerMethods: String = """
            override func viewDidLoad() {
                super.viewDidLoad()
                update(with: initialState)
            }

            override func viewWillAppear() {
                super.viewWillAppear()
                observe(statePublisher).store(in: &cancellables)
            }

            override func viewWillDisappear() {
                super.viewWillDisappear()
                cancellables.removeAll()
            }
            """

        static let viewControllerMethodsForRootNode: String = """
            override func viewDidLoad() {
                super.viewDidLoad()
                update(with: initialState)
            }

            override func viewWillAppear() {
                super.viewWillAppear()
                observe(statePublisher).store(in: &cancellables)
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
        UIFramework(
            framework: .appKit,
            viewControllerProperties: "",
            viewControllerMethods: Defaults.viewControllerMethods,
            viewControllerMethodsForRootNode: Defaults.viewControllerMethodsForRootNode
        )
    }
}
