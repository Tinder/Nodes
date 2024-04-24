//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

import Codextended

public struct UIFramework: Equatable, Codable {

    public enum Kind: String, CaseIterable, Sendable {

        case appKit = "AppKit"
        case uiKit = "UIKit"
        case swiftUI = "SwiftUI"
        case custom = "Custom"

        public var name: String {
            rawValue
        }
    }

    public enum Framework: Equatable, Codable {

        case appKit
        case uiKit
        case uiKitSwiftUI

        // swiftlint:disable:next enum_case_associated_values_count
        case custom(name: String,
                    import: String,
                    viewControllerType: String,
                    viewControllerSuperParameters: String,
                    viewControllerMethods: String)

        internal var kind: Kind {
            switch self {
            case .appKit:
                return .appKit
            case .uiKit:
                return .uiKit
            case .uiKitSwiftUI:
                return .swiftUI
            case .custom:
                return .custom
            }
        }

        internal var name: String {
            switch self {
            case .appKit, .uiKit, .uiKitSwiftUI:
                return kind.name
            case let .custom(name, _, _, _, _):
                return name
            }
        }

        internal var `import`: String {
            switch self {
            case .appKit, .uiKit:
                return name
            case .uiKitSwiftUI:
                return "SwiftUI"
            case let .custom(_, `import`, _, _, _):
                return `import`
            }
        }

        internal var viewControllerType: String {
            switch self {
            case .appKit:
                return "NSViewController"
            case .uiKit:
                return "UIViewController"
            case .uiKitSwiftUI:
                return "UIHostingController"
            case let .custom(_, _, viewControllerType, _, _):
                return viewControllerType
            }
        }

        internal var viewControllerSuperParameters: String {
            switch self {
            case .appKit, .uiKit:
                return "nibName: nil, bundle: nil"
            case .uiKitSwiftUI:
                return ""
            case let .custom(_, _, _, viewControllerSuperParameters, _):
                return viewControllerSuperParameters
            }
        }

        internal var viewControllerMethods: String {
            switch self {
            case .appKit:
                return """
                    @available(*, unavailable)
                    internal required init?(coder: NSCoder) {
                        preconditionFailure("init(coder:) has not been implemented")
                    }

                    override internal func loadView() {
                        view = NSView()
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
            case .uiKit:
                return """
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
            case .uiKitSwiftUI:
                return ""
            case let .custom(_, _, _, _, viewControllerMethods):
                return viewControllerMethods
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
            guard let kind: Kind = .init(rawValue: framework)
            else {
                throw DecodingError.typeMismatch(Self.self, DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Unsupported framework: \(framework)"
                ))
            }
            switch kind {
            case .appKit:
                self = .appKit
            case .uiKit:
                self = .uiKit
            case .swiftUI:
                self = .uiKitSwiftUI
            case .custom:
                throw DecodingError.typeMismatch(Self.self, DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Custom framework must be an object."
                ))
            }
        }

        private static func decodeUsingKeyedContainer(with decoder: Decoder) throws -> Self {
            let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
            guard container.allKeys.count == 1, let key: CodingKeys = container.allKeys.first
            else {
                throw DecodingError.typeMismatch(Self.self, DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Expected only one key."
                ))
            }
            switch key {
            case .appKit:
                return .appKit
            case .uiKit:
                return .uiKit
            case .uiKitSwiftUI:
                return .uiKitSwiftUI
            case .custom:
                let container: KeyedDecodingContainer<CustomCodingKeys> = try container
                    .nestedContainer(keyedBy: CustomCodingKeys.self, forKey: .custom)
                let name: String = try container
                    .decode(String.self, forKey: .name)
                let `import`: String = try container
                    .decode(String.self, forKey: .import)
                let viewControllerType: String = try container
                    .decode(String.self, forKey: .viewControllerType)
                let viewControllerSuperParameters: String? = try? container
                    .decode(String.self, forKey: .viewControllerSuperParameters)
                let viewControllerMethods: String? = try? container
                    .decode(String.self, forKey: .viewControllerMethods)
                let required: [(key: String, value: String)] = [
                    (key: "name", value: name),
                    (key: "import", value: `import`),
                    (key: "viewControllerType", value: viewControllerType)
                ]
                for (key, value): (String, String) in required
                where value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    throw Config.ConfigError.emptyStringNotAllowed(key: key)
                }
                return .custom(name: name,
                               import: `import`,
                               viewControllerType: viewControllerType,
                               viewControllerSuperParameters: viewControllerSuperParameters ?? "",
                               viewControllerMethods: viewControllerMethods ?? "")
            }
        }
    }

    public let framework: Framework

    public var kind: Kind { framework.kind }
    public var name: String { framework.name }
    public var `import`: String { framework.import }
    public var viewControllerType: String { framework.viewControllerType }
    public var viewControllerSuperParameters: String { framework.viewControllerSuperParameters }
    public var viewControllerMethods: String { framework.viewControllerMethods }

    public init(framework: Framework) {
        self.framework = framework
    }

    public init(from decoder: Decoder) throws {
        framework = try decoder.decode(CodingKeys.framework)
    }
}
