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

        // swiftlint:disable:next function_body_length
        public init(from decoder: Decoder) throws { // swiftlint:disable:this cyclomatic_complexity
            let container: SingleValueDecodingContainer
            let framework: String
            do {
                container = try decoder.singleValueContainer()
                framework = try container.decode(String.self)
            } catch {
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
                    self = .appKit
                case .uiKit:
                    self = .uiKit
                case .swiftUI:
                    self = .swiftUI
                case .custom:
                    let container: KeyedDecodingContainer<CustomCodingKeys> = try container.nestedContainer(
                        keyedBy: CustomCodingKeys.self, forKey: .custom
                    )
                    let name: String? = try container.decodeIfPresent(String.self, forKey: .name)
                    let `import`: String? = try container.decodeIfPresent(String.self, forKey: .import)
                    let viewControllerType: String = try container.decode(String.self, forKey: .viewControllerType)
                    self = .custom(name: name, import: `import`, viewControllerType: viewControllerType)
                }
                return
            }
            guard let kind: Kind = .init(rawValue: framework) else {
                let codingPath: [CodingKey] = container.codingPath
                let debugDescription: String = "Unsupported framework: \(framework)"
                let error: DecodingError.Context = .init(codingPath: codingPath, debugDescription: debugDescription)
                throw DecodingError.typeMismatch(Self.self, error)
            }
            switch kind {
            case .appKit:
                self = .appKit
            case .uiKit:
                self = .uiKit
            case .swiftUI:
                self = .swiftUI
            default:
                let codingPath: [CodingKey] = container.codingPath
                let debugDescription: String = "Custom framework must be object."
                let error: DecodingError.Context = .init(codingPath: codingPath, debugDescription: debugDescription)
                throw DecodingError.typeMismatch(Self.self, error)
            }
        }
    }

    public let framework: Framework

    public var viewControllerSuperParameters: String
    public var viewControllerProperties: String
    public var viewControllerMethods: String
    public var viewControllerMethodsForRootNode: String

    public var `import`: String? { framework.import }
    public var viewControllerType: String { framework.viewControllerType }
    public var kind: Kind { framework.kind }
    public var name: String { framework.name }

    public init(framework: Framework) { // swiftlint:disable:this function_body_length
        self.framework = framework
        switch framework {
        case .appKit:
            viewControllerSuperParameters = ""
            viewControllerProperties = ""
            viewControllerMethods = ""
            viewControllerMethodsForRootNode = ""
        case .uiKit:
            viewControllerSuperParameters = "nibName: nil, bundle: nil"
            viewControllerProperties = ""
            viewControllerMethods = """
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
                """
            viewControllerMethodsForRootNode = """
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
        case .swiftUI:
            viewControllerSuperParameters = ""
            viewControllerProperties = ""
            viewControllerMethods = ""
            viewControllerMethodsForRootNode = """
                override func viewDidAppear(_ animated: Bool) {
                    super.viewDidAppear(animated)
                    receiver?.viewDidAppear()
                }
                """
        case .custom:
            viewControllerSuperParameters = ""
            viewControllerProperties = ""
            viewControllerMethods = ""
            viewControllerMethodsForRootNode = ""
        }
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
}
