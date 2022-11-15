//
//  UIFramework.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/10/22.
//

import Codextended

public struct UIFramework: Equatable, Codable {

    public enum Kind: String, CaseIterable {
        case appKit = "AppKit"
        case uiKit = "UIKit"
        case swiftUI = "SwiftUI"
        case custom = "Custom"
    }

    public enum Framework: Equatable, Codable {

        private static func framework(fromKeyedContainer decoder: Decoder) throws -> Self {
            let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
            var allKeys: ArraySlice<CodingKeys> = .init(container.allKeys)
            guard let onlyKey: CodingKeys = allKeys.popFirst(), allKeys.isEmpty else {
                let codingPath: [CodingKey] = container.codingPath
                let debugDescription: String = "Invalid number of keys found, expected one."
                let error: DecodingError.Context = .init(codingPath: codingPath, debugDescription: debugDescription)
                throw DecodingError.typeMismatch(Self.self, error)
            }
            switch onlyKey {
            case .appKit:
                return .appKit
            case .uiKit:
                return .uiKit
            case .swiftUI:
                return .swiftUI
            case .custom:
                let container: KeyedDecodingContainer<CustomCodingKeys> = try container.nestedContainer(
                    keyedBy: CustomCodingKeys.self, forKey: .custom
                )
                let name: String? = try container.decodeIfPresent(String.self, forKey: .name)
                let `import`: String? = try container.decodeIfPresent(String.self, forKey: .import)
                let viewControllerType: String = try container.decode(String.self, forKey: .viewControllerType)
                return .custom(name: name, import: `import`, viewControllerType: viewControllerType)
            }
        }

        private static func framework(
            fromSingleValueContainer container: SingleValueDecodingContainer,
            frameworkName: String
        ) throws -> Self {
            guard let kind: UIFramework.Kind = .init(rawValue: frameworkName) else {
                let codingPath: [CodingKey] = container.codingPath
                let debugDescription: String = "Unsupported framework: \(frameworkName)"
                let error: DecodingError.Context = .init(codingPath: codingPath, debugDescription: debugDescription)
                throw DecodingError.typeMismatch(Self.self, error)
            }
            switch kind {
            case .appKit:
                return .appKit
            case .uiKit:
                return .uiKit
            case .swiftUI:
                return .swiftUI
            default:
                let codingPath: [CodingKey] = container.codingPath
                let debugDescription: String = "Custom framework must be object."
                let error: DecodingError.Context = .init(codingPath: codingPath, debugDescription: debugDescription)
                throw DecodingError.typeMismatch(Self.self, error)
            }
        }

        case appKit
        case uiKit
        case swiftUI
        case custom(name: String?, import: String?, viewControllerType: String)

        internal var kind: Kind {
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

        internal var name: String {
            switch self {
            case .appKit, .uiKit, .swiftUI:
                return kind.rawValue
            case let .custom(name, _, _):
                return name ?? kind.rawValue
            }
        }

        internal var `import`: String? {
            switch self {
            case .appKit, .uiKit, .swiftUI:
                return name
            case let .custom(_, `import`, _):
                return `import`
            }
        }

        internal var viewControllerType: String {
            switch self {
            case .appKit:
                return "NSViewController"
            case .uiKit:
                return "UIViewController"
            case .swiftUI:
                return "AbstractViewHostingController"
            case let .custom(_, _, viewControllerType):
                return viewControllerType
            }
        }

        public init(from decoder: Decoder) throws {
            let container: SingleValueDecodingContainer
            let framework: String
            do {
                container = try decoder.singleValueContainer()
                framework = try container.decode(String.self)
            } catch {
                self = try Self.framework(fromKeyedContainer: decoder)
                return
            }
            self = try Self.framework(fromSingleValueContainer: container, frameworkName: framework)
        }
    }

    public let framework: Framework

    public var kind: Kind { framework.kind }
    public var name: String { framework.name }
    public var `import`: String? { framework.import }
    public var viewControllerType: String { framework.viewControllerType }

    public var viewControllerSuperParameters: String
    public var viewControllerProperties: String
    public var viewControllerMethods: String
    public var viewControllerMethodsForRootNode: String

    public init(framework: Framework) {
        self.framework = framework
        let defaults: UIFrameworkDefaults = Self.defaults(for: framework.kind)
        viewControllerSuperParameters = defaults.viewControllerSuperParameters
        viewControllerProperties = defaults.viewControllerProperties
        viewControllerMethods = defaults.viewControllerMethods
        viewControllerMethodsForRootNode = defaults.viewControllerMethodsForRootNode
    }

    public init(from decoder: Decoder) throws {
        framework = try decoder.decode(CodingKeys.framework.stringValue)
        let defaults: UIFramework = .init(framework: framework)
        viewControllerSuperParameters =
            (try? decoder.decodeString(CodingKeys.viewControllerSuperParameters.stringValue))
            ?? defaults.viewControllerSuperParameters
        viewControllerProperties =
            (try? decoder.decodeString(CodingKeys.viewControllerProperties.stringValue))
            ?? defaults.viewControllerProperties
        viewControllerMethods =
            (try? decoder.decodeString(CodingKeys.viewControllerMethods.stringValue))
            ?? defaults.viewControllerMethods
        viewControllerMethodsForRootNode =
            (try? decoder.decodeString(CodingKeys.viewControllerMethodsForRootNode.stringValue))
            ?? defaults.viewControllerMethodsForRootNode
    }

    private static func defaults(for kind: UIFramework.Kind) -> UIFrameworkDefaults {
        switch kind {
        case .appKit:
            return UIFrameworkAppKitDefaults()
        case .uiKit:
            return UIFrameworkUIKitDefaults()
        case .swiftUI:
            return UIFrameworkSwiftUIDefaults()
        case .custom:
            return UIFrameworkCustomDefaults()
        }
    }
}
