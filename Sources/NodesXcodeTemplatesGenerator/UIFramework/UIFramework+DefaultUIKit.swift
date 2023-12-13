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
                view.backgroundColor = .systemBackground
                update(with: initialState)
            }

            override internal func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
                observe(statePublisher).store(in: &cancellables)
            }

            override internal func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)
                cancellables.cancelAll()
            }
            """
    }

    internal static func makeDefaultUIKitFramework() -> UIFramework {
        UIFramework(
            framework: .uiKit,
            viewControllerProperties: "",
            viewControllerMethods: Defaults.viewControllerMethods
        )
    }
}
