//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

extension UIFramework {

    private enum Defaults {

        static let viewControllerMethods: String = """
            @available(*, unavailable)
            internal required init?(coder: NSCoder) {
                preconditionFailure("init(coder:) has not been implemented")
            }

            override internal func viewDidLoad() {
                super.viewDidLoad()
                update(with: initialState)
            }

            override internal func viewWillAppear() {
                super.viewWillAppear()
                observe(statePublisher).store(in: &cancellables)
            }

            override internal func viewWillDisappear() {
                super.viewWillDisappear()
                cancellables.cancelAll()
            }
            """

        static let viewControllerMethodsForRootNode: String = """
            @available(*, unavailable)
            internal required init?(coder: NSCoder) {
                preconditionFailure("init(coder:) has not been implemented")
            }

            override internal func viewDidLoad() {
                super.viewDidLoad()
                update(with: initialState)
            }

            override internal func viewWillAppear() {
                super.viewWillAppear()
                observe(statePublisher).store(in: &cancellables)
            }

            override internal func viewDidAppear() {
                super.viewDidAppear()
                receiver?.viewDidAppear()
            }

            override internal func viewWillDisappear() {
                super.viewWillDisappear()
                cancellables.cancelAll()
            }
            """
    }

    internal static func makeDefaultAppKitFramework() -> UIFramework {
        UIFramework(
            framework: .appKit,
            viewControllerProperties: "",
            viewControllerMethods: Defaults.viewControllerMethods,
            viewControllerMethodsForRootNode: Defaults.viewControllerMethodsForRootNode,
            viewControllableMockContents: ""
        )
    }
}
