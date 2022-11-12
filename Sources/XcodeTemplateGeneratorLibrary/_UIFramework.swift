//
//  UIFramework.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/10/22.
//

public struct UIFramework: Equatable, Decodable, Encodable {

    public enum Kind: CaseIterable {
        case appKit, uiKit, swiftUI, custom
    }

    public enum Framework: Equatable, Decodable, Encodable {

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
            case .appKit:
                return "AppKit"
            case .uiKit:
                return "UIKit"
            case .swiftUI:
                return "SwiftUI"
            case let .custom(name, _, _):
                return name ?? "Custom"
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
            do {
                let container: SingleValueDecodingContainer = try decoder.singleValueContainer()
                let kind: String = try container.decode(String.self)
                switch kind {
                case "AppKit":
                    self = .appKit
                case "UIKit":
                    self = .uiKit
                case "SwiftUI":
                    self = .swiftUI
                default:
                    let debugDescription: String = "Custom framework must be object."
                    let error: DecodingError.Context = .init(codingPath: container.codingPath,
                                                             debugDescription: debugDescription,
                                                             underlyingError: nil)
                    throw DecodingError.typeMismatch(Framework.self, error)
                }
            } catch {
                let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
                var allKeys: ArraySlice<CodingKeys> = .init(container.allKeys)
                guard let onlyKey: CodingKeys = allKeys.popFirst(), allKeys.isEmpty else {
                    let debugDescription: String = "Invalid number of keys found, expected one."
                    let error: DecodingError.Context = .init(codingPath: container.codingPath,
                                                             debugDescription: debugDescription,
                                                             underlyingError: nil)
                    throw DecodingError.typeMismatch(Framework.self, error)
                }
                switch onlyKey {
                case .appKit:
                    self = .appKit
                case .uiKit:
                    self = .uiKit
                case .swiftUI:
                    self = .swiftUI
                case .custom:
                    let nestedContainer: KeyedDecodingContainer<CustomCodingKeys> = try container.nestedContainer(
                        keyedBy: CustomCodingKeys.self, forKey: CodingKeys.custom
                    )
                    let name: String? = try nestedContainer.decodeIfPresent(String.self, forKey: CustomCodingKeys.name)
                    let `import`: String? = try nestedContainer.decodeIfPresent(
                        String.self,
                        forKey: CustomCodingKeys.import
                    )
                    let viewControllerType: String = try nestedContainer.decode(
                        String.self,
                        forKey: CustomCodingKeys.viewControllerType
                    )
                    self = .custom(name: name, import: `import`, viewControllerType: viewControllerType)
                }
            }
        }
    }

    public let framework: Framework
    public var viewControllerSuperParameters: String
    public var viewControllerProperties: String
    public var viewControllerMethods: String
    public var viewControllerMethodsForRootNode: String

    internal var kind: Kind { framework.kind }
    internal var name: String { framework.name }
    internal var `import`: String? { framework.import }
    internal var viewControllerType: String { framework.viewControllerType }

    public init(framework: Framework) {
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
        framework = try decoder.decode("framework")
        let defaults: UIFramework = .init(framework: framework)
        viewControllerSuperParameters =
            (try? decoder.decodeString("viewControllerSuperParameters"))
            ?? defaults.viewControllerSuperParameters
        viewControllerProperties =
            (try? decoder.decodeString("viewControllerProperties"))
            ?? defaults.viewControllerProperties
        viewControllerMethods =
            (try? decoder.decodeString("viewControllerMethods"))
            ?? defaults.viewControllerMethods
        viewControllerMethodsForRootNode =
            (try? decoder.decodeString("viewControllerMethodsForRootNode"))
            ?? defaults.viewControllerMethodsForRootNode
    }
}
