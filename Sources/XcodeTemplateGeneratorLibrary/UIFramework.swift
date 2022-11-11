//
//  File.swift
//  
//
//  Created by Garric Nahapetian on 11/10/22.
//


public enum UIFramework: Equatable, Decodable, CustomStringConvertible {

    public struct Options: Equatable, Decodable {

        public var viewControllerSuperParameters: String
        public var viewControllerProperties: String
        public var viewControllerMethods: String
        public var viewControllerMethodsForRootNode: String

        public init(
            viewControllerSuperParameters: String,
            viewControllerProperties: String,
            viewControllerMethods: String,
            viewControllerMethodsForRootNode: String
        ) {
            self.viewControllerSuperParameters = viewControllerSuperParameters
            self.viewControllerProperties = viewControllerProperties
            self.viewControllerMethods = viewControllerMethods
            self.viewControllerMethodsForRootNode = viewControllerMethodsForRootNode
        }
    }

    public struct CustomOptions: Equatable, Decodable {

        public var uiFrameworkImport: String
        public var viewControllerType: String
        public var viewControllerSuperParameters: String
        public var viewControllerProperties: String
        public var viewControllerMethods: String
        public var viewControllerMethodsForRootNode: String

        public init(
            uiFrameworkImport: String,
            viewControllerType: String,
            viewControllerSuperParameters: String,
            viewControllerProperties: String,
            viewControllerMethods: String,
            viewControllerMethodsForRootNode: String
        ) {
            self.uiFrameworkImport = uiFrameworkImport
            self.viewControllerType = viewControllerType
            self.viewControllerSuperParameters = viewControllerSuperParameters
            self.viewControllerProperties = viewControllerProperties
            self.viewControllerMethods = viewControllerMethods
            self.viewControllerMethodsForRootNode = viewControllerMethodsForRootNode
        }
    }

    public enum Kind: Equatable {
        case appKit
        case uiKit
        case swiftUI
        case custom
    }

    case appKit(options: Options)
    case uiKit(options: Options)
    case swiftUI(options: Options)
    case custom(options: CustomOptions)

    public var description: String {
        guard case .custom = self else {
            return uiFrameworkImport
        }
        return "Custom"
    }

    public var kind: Kind {
        switch self {
        case .appKit:
            return .appKit
        case .uiKit:
            return .uiKit
        case .swiftUI:
            return .swiftUI
        case .custom:
            return .custom
        }
    }

    public static func appKit() -> UIFramework {
        .appKit(options: .appKitDefaultOptions())
    }

    public static func uiKit() -> UIFramework {
        .uiKit(options: .uiKitDefaultOptions())
    }

    public static func swiftUI() -> UIFramework {
        .swiftUI(options: .swiftUIDefaultOptions())
    }
}

public extension UIFramework {

    var name: String { description }

    var uiFrameworkImport: String {
        switch self {
        case .appKit:
            return "AppKit"
        case .uiKit:
            return "UIKit"
        case .swiftUI:
            return "SwiftUI"
        case let .custom(options):
            return options.uiFrameworkImport
        }
    }

    var viewControllerType: String {
        switch self {
        case .appKit:
            return "NSViewController"
        case .uiKit:
            return "UIViewController"
        case .swiftUI:
            return "AbstractViewHostingController"
        case let .custom(options):
            return options.viewControllerType
        }
    }

    var viewControllerSuperParameters: String {
        switch self {
        case let .appKit(options), let .uiKit(options), let .swiftUI(options):
            return options.viewControllerSuperParameters
        case let .custom(options):
            return options.viewControllerSuperParameters
        }
    }

    var viewControllerProperties: String {
        switch self {
        case let .appKit(options), let .uiKit(options), let .swiftUI(options):
            return options.viewControllerProperties
        case let .custom(options):
            return options.viewControllerProperties
        }
    }

    var viewControllerMethods: String {
        switch self {
        case let .appKit(options), let .uiKit(options), let .swiftUI(options):
            return options.viewControllerMethods
        case let .custom(options):
            return options.viewControllerMethods
        }
    }

    var viewControllerMethodsForRootNode: String {
        switch self {
        case let .appKit(options), let .uiKit(options), let .swiftUI(options):
            return options.viewControllerMethodsForRootNode
        case let .custom(options):
            return options.viewControllerMethodsForRootNode
        }
    }
}

extension UIFramework.Options {

    public static func appKitDefaultOptions() -> UIFramework.Options {
        UIFramework.Options(
            viewControllerSuperParameters: "",
            viewControllerProperties: "",
            viewControllerMethods: "",
            viewControllerMethodsForRootNode: ""
        )
    }

    public static func uiKitDefaultOptions() -> UIFramework.Options {
        UIFramework.Options(
            viewControllerSuperParameters: "nibName: nil, bundle: nil",
            viewControllerProperties: "",
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
                """
        )
    }

    public static func swiftUIDefaultOptions() -> UIFramework.Options {
        UIFramework.Options(
            viewControllerSuperParameters: "",
            viewControllerProperties: "",
            viewControllerMethods: "",
            viewControllerMethodsForRootNode: """
                override func viewDidAppear(_ animated: Bool) {
                    super.viewDidAppear(animated)
                    receiver?.viewDidAppear()
                }
                """
        )
    }
}
