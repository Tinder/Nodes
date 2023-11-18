//
//  Copyright © 2022 Tinder (Match Group, LLC)
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
        case custom(name: String,
                    import: String,
                    viewControllerType: String,
                    viewControllerSuperParameters: String)

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
            case let .custom(name, _, _, _):
                return name
            }
        }

        internal var `import`: String {
            switch self {
            case .appKit, .uiKit, .swiftUI:
                return name
            case let .custom(_, `import`, _, _):
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
                return "UIHostingController"
            case let .custom(_, _, viewControllerType, _):
                return viewControllerType
            }
        }

        internal var viewControllerSuperParameters: String {
            switch self {
            case .appKit, .uiKit:
                return "nibName: nil, bundle: nil"
            case .swiftUI:
                return ""
            case let .custom(_, _, _, viewControllerSuperParameters):
                return viewControllerSuperParameters
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
                let name: String = try container.decode(String.self, forKey: .name)
                let `import`: String = try container.decode(String.self, forKey: .import)
                let viewControllerType: String = try container.decode(String.self, forKey: .viewControllerType)
                let viewControllerSuperParameters: String = try container.decode(String.self,
                                                                                 forKey: .viewControllerSuperParameters)
                let required: [(key: String, value: String)] = [
                    (key: "name", value: name),
                    (key: "import", value: `import`),
                    (key: "viewControllerType", value: viewControllerType)
                ]
                for (key, value) in required where value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    throw Config.ConfigError.emptyStringNotAllowed(key: key)
                }
                return .custom(name: name,
                               import: `import`,
                               viewControllerType: viewControllerType,
                               viewControllerSuperParameters: viewControllerSuperParameters)
            }
        }
    }

    public let framework: Framework

    public var kind: Kind { framework.kind }
    public var name: String { framework.name }
    public var `import`: String { framework.import }
    public var viewControllerType: String { framework.viewControllerType }
    public var viewControllerSuperParameters: String { framework.viewControllerSuperParameters }

    public var viewControllerProperties: String
    public var viewControllerMethods: String
    public var viewControllableMockContents: String

    public init(framework: Framework) {
        switch framework.kind {
        case .appKit:
            self = .makeDefaultAppKitFramework()
        case .uiKit:
            self = .makeDefaultUIKitFramework()
        case .swiftUI:
            self = .makeDefaultSwiftUIFramework()
        case .custom:
            self = .makeDefaultFramework(for: framework)
        }
    }

    public init(from decoder: Decoder) throws {
        framework = try decoder.decode(CodingKeys.framework)
        let defaults: Self = .init(framework: framework)
        viewControllerProperties =
            (try? decoder.decodeString(CodingKeys.viewControllerProperties))
            ?? defaults.viewControllerProperties
        viewControllerMethods =
            (try? decoder.decodeString(CodingKeys.viewControllerMethods))
            ?? defaults.viewControllerMethods
        viewControllableMockContents =
            (try? decoder.decodeString(CodingKeys.viewControllableMockContents))
            ?? defaults.viewControllableMockContents
    }

    internal init(
        framework: Framework,
        viewControllerProperties: String,
        viewControllerMethods: String,
        viewControllableMockContents: String
    ) {
        self.framework = framework
        self.viewControllerProperties = viewControllerProperties
        self.viewControllerMethods = viewControllerMethods
        self.viewControllableMockContents = viewControllableMockContents
    }
}
