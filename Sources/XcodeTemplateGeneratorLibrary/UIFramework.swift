//
//  File.swift
//  
//
//  Created by Garric Nahapetian on 11/10/22.
//

public enum UIFramework: Equatable, Decodable, CustomStringConvertible, Encodable {

    case appKit(Options)
    case uiKit(Options)
    case swiftUI(Options)
    case custom(CustomOptions)

    public var description: String {
        guard case .custom = self else {
            return uiFrameworkImport
        }
        return "Custom"
    }
}

internal extension UIFramework {

    static let appKitWithDefaultOptions: UIFramework = .appKit(.appKitDefaultOptions)
    static let uiKitWithDefaultOptions: UIFramework = .uiKit(.uiKitDefaultOptions)
    static let swiftUIWithDefaultOptions: UIFramework = .swiftUI(.swiftUIDefaultOptions)

    static let allCasesWithDefaultOptions: [UIFramework] = [
        .appKitWithDefaultOptions,
        .uiKitWithDefaultOptions,
        .swiftUIWithDefaultOptions
    ]

    var isUIKit: Bool {
        if case .uiKit = self {
            return true
        } else {
            return false
        }
    }

    var isSwiftUI: Bool {
        if case .swiftUI = self {
            return true
        } else {
            return false
        }
    }

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
            return "View"
        case let .custom(options):
            return options.viewControllerType
        }
    }

    var viewControllerMethods: String {
        switch self {
        case let .appKit(options):
            return options.viewControllerMethods
        case let .uiKit(options):
            return options.viewControllerMethods
        case let .swiftUI(options):
            return options.viewControllerMethods
        case let .custom(options):
            return options.viewControllerMethods
        }
    }

    var viewControllerMethodsForRootNode: String {
        switch self {
        case let .appKit(options):
            return options.viewControllerMethodsForRootNode
        case let .uiKit(options):
            return options.viewControllerMethodsForRootNode
        case let .swiftUI(options):
            return options.viewControllerMethodsForRootNode
        case let .custom(options):
            return options.viewControllerMethodsForRootNode
        }
    }

    var viewControllerProperties: String {
        switch self {
        case let .appKit(options):
            return options.viewControllerProperties
        case let .uiKit(options):
            return options.viewControllerProperties
        case let .swiftUI(options):
            return options.viewControllerProperties
        case let .custom(options):
            return options.viewControllerProperties
        }
    }

    var viewControllerSuperParameters: String {
        switch self {
        case let .appKit(options):
            return options.viewControllerSuperParameters
        case let .uiKit(options):
            return options.viewControllerSuperParameters
        case let .swiftUI(options):
            return options.viewControllerSuperParameters
        case let .custom(options):
            return options.viewControllerSuperParameters
        }
    }
}
