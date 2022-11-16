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
                self = try Self.decodeUsingKeyedContainer(with: decoder)
                return
            }
            guard let kind: Kind = .init(rawValue: framework) else {
                throw DecodingError.typeMismatch(Self.self, DecodingError.Context(
                    codingPath: container.codingPath, debugDescription: "Unsupported framework: \(framework)"
                ))
            }
            switch kind {
            case .appKit:
                self = .appKit
            case .uiKit:
                self = .uiKit
            case .swiftUI:
                self = .swiftUI
            default:
                throw DecodingError.typeMismatch(Self.self, DecodingError.Context(
                    codingPath: container.codingPath, debugDescription: "Custom framework must be an object."
                ))
            }
        }

        private static func decodeUsingKeyedContainer(with decoder: Decoder) throws -> Self {
            let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
            guard container.allKeys.count == 1, let key: CodingKeys = container.allKeys.first else {
                throw DecodingError.typeMismatch(Self.self, DecodingError.Context(
                    codingPath: container.codingPath, debugDescription: "Expected only one key."
                ))
            }
            switch key {
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
                return try .custom(
                    name: container.decodeIfPresent(String.self, forKey: .name),
                    import: container.decodeIfPresent(String.self, forKey: .import),
                    viewControllerType: container.decode(String.self, forKey: .viewControllerType)
                )
            }
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
        switch framework.kind {
        case .appKit:
            self = DefaultsAppKit().makeUIFramework()
        case .uiKit:
            self = DefaultsUIKit().makeUIFramework()
        case .swiftUI:
            self = DefaultsSwiftUI().makeUIFramework()
        case .custom:
            self = Defaults().makeUIFramework(for: framework)
        }
    }

    public init(from decoder: Decoder) throws {
        framework = try decoder.decode(CodingKeys.framework.stringValue)
        let defaults: UIFramework = .init(framework: framework)
        viewControllerSuperParameters =
            (try? decoder.decodeString(CodingKeys.viewControllerSuperParameters))
            ?? defaults.viewControllerSuperParameters
        viewControllerProperties =
            (try? decoder.decodeString(CodingKeys.viewControllerProperties))
            ?? defaults.viewControllerProperties
        viewControllerMethods =
            (try? decoder.decodeString(CodingKeys.viewControllerMethods))
            ?? defaults.viewControllerMethods
        viewControllerMethodsForRootNode =
            (try? decoder.decodeString(CodingKeys.viewControllerMethodsForRootNode))
            ?? defaults.viewControllerMethodsForRootNode
    }

    internal init(
        framework: Framework,
        viewControllerSuperParameters: String,
        viewControllerProperties: String,
        viewControllerMethods: String,
        viewControllerMethodsForRootNode: String
    ) {
        self.framework = framework
        self.viewControllerSuperParameters = viewControllerSuperParameters
        self.viewControllerProperties = viewControllerProperties
        self.viewControllerMethods = viewControllerMethods
        self.viewControllerMethodsForRootNode = viewControllerMethodsForRootNode
    }
}
