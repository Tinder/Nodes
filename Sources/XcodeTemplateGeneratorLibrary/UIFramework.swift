//
//  File.swift
//  
//
//  Created by Garric Nahapetian on 11/10/22.
//

public enum UIFramework: Equatable, Decodable, CustomStringConvertible, Encodable {

    public struct Options: Equatable, Decodable, Encodable {

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

    public struct CustomOptions: Equatable, Decodable, Encodable {

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

    enum Kind: Equatable {
        case appKit
        case uiKit
        case swiftUI
        case custom
    }

    var name: String { description }

    var kind: Kind {
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
