//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

extension UIFramework {

    private enum Defaults {

        static let viewControllerMethods: String = """
            override internal func viewDidLoad() {
                super.viewDidLoad()
                view.backgroundColor = .systemBackground
                update(with: initialState)
            }

            override internal func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
                cancelSubscriptions()
                observe(statePublisher).store(in: &cancellables)
            }

            override internal func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)
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
                view.backgroundColor = .systemBackground
                update(with: initialState)
            }

            override internal func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
                cancelSubscriptions()
                observe(statePublisher).store(in: &cancellables)
            }

            override internal func viewDidAppear(_ animated: Bool) {
                super.viewDidAppear(animated)
                receiver?.viewDidAppear()
            }

            override internal func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)
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

    internal static func makeDefaultUIKitFramework() -> UIFramework {
        UIFramework(
            framework: .uiKit,
            viewControllerProperties: "",
            viewControllerMethods: Defaults.viewControllerMethods,
            viewControllerMethodsForRootNode: Defaults.viewControllerMethodsForRootNode
        )
    }
}
