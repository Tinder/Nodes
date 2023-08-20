//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

extension UIFramework {

    private enum Defaults {

        static let viewControllerMethods: String = """
            override internal func viewDidLoad() {
                super.viewDidLoad()
                update(with: initialState)
            }

            override internal func viewWillAppear() {
                super.viewWillAppear()
                cancelSubscriptions()
                observe(statePublisher).store(in: &cancellables)
            }

            override internal func viewWillDisappear() {
                super.viewWillDisappear()
                cancelSubscriptions()
            }

            private func cancelSubscriptions() {
                cancellables.forEach { cancellable in
                    cancellable.cancel()
                    LeakDetector.detect(cancellable)
                }
                cancellables.removeAll()
            }
            """

        static let viewControllerMethodsForRootNode: String = """
            override internal func viewDidLoad() {
                super.viewDidLoad()
                update(with: initialState)
            }

            override internal func viewWillAppear() {
                super.viewWillAppear()
                cancelSubscriptions()
                observe(statePublisher).store(in: &cancellables)
            }

            override internal func viewDidAppear() {
                super.viewDidAppear()
                receiver?.viewDidAppear()
            }

            override internal func viewWillDisappear() {
                super.viewWillDisappear()
                cancelSubscriptions()
            }

            private func cancelSubscriptions() {
                cancellables.forEach { cancellable in
                    cancellable.cancel()
                    LeakDetector.detect(cancellable)
                }
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
