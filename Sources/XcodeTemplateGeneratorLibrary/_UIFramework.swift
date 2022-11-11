//
//  File.swift
//  
//
//  Created by Garric Nahapetian on 11/10/22.
//

public struct UIFramework: Equatable, Decodable, Encodable {

    public enum Kind: Equatable, Decodable, CaseIterable, Encodable {

        public static var allCases: [UIFramework.Kind] {
            []
        }

        case appKit
        case uiKit
        case swiftUI
        case custom(name: String?, uiFrameworkImport: String?, viewControllerType: String)

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

        internal var uiFrameworkImport: String? {
            switch self {
            case .appKit, .uiKit, .swiftUI:
                return name
            case let .custom(_, uiFrameworkImport, _):
                return uiFrameworkImport
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
                    let error: DecodingError.Context = .init(codingPath: container.codingPath,
                                                             debugDescription: "Custom UIFramework must be object.",
                                                             underlyingError: nil)
                    throw DecodingError.typeMismatch(UIFramework.Kind.self, error)
                }
            } catch {
                let container: KeyedDecodingContainer<UIFramework.Kind.CodingKeys> = try decoder.container(
                    keyedBy: UIFramework.Kind.CodingKeys.self
                )
                var allKeys: ArraySlice<UIFramework.Kind.CodingKeys> = .init(container.allKeys)
                guard let onlyKey: UIFramework.Kind.CodingKeys = allKeys.popFirst(), allKeys.isEmpty else {
                    let error: DecodingError.Context = .init(
                        codingPath: container.codingPath,
                        debugDescription: "Invalid number of keys found, expected one.",
                        underlyingError: nil
                    )
                    throw DecodingError.typeMismatch(UIFramework.Kind.self, error)
                }
                switch onlyKey {
                case .appKit:
                    self = .appKit
                case .uiKit:
                    self = .uiKit
                case .swiftUI:
                    self = .swiftUI
                case .custom:
                    let nestedContainer: KeyedDecodingContainer<UIFramework.Kind.CustomCodingKeys> =
                    try container.nestedContainer(keyedBy: UIFramework.Kind.CustomCodingKeys.self,
                                                  forKey: UIFramework.Kind.CodingKeys.custom)
                    let name: String? = try nestedContainer.decodeIfPresent(
                        String.self,
                        forKey: UIFramework.Kind.CustomCodingKeys.name
                    )
                    let uiFrameworkImport: String? = try nestedContainer.decodeIfPresent(
                        String.self,
                        forKey: UIFramework.Kind.CustomCodingKeys.uiFrameworkImport
                    )
                    let viewControllerType: String = try nestedContainer.decode(
                        String.self,
                        forKey: UIFramework.Kind.CustomCodingKeys.viewControllerType
                    )
                    self = UIFramework.Kind.custom(name: name,
                                                   uiFrameworkImport: uiFrameworkImport,
                                                   viewControllerType: viewControllerType)
                }
            }
        }
    }

    public let kind: Kind
    public var viewControllerSuperParameters: String
    public var viewControllerProperties: String
    public var viewControllerMethods: String
    public var viewControllerMethodsForRootNode: String

    internal var name: String { kind.name }
    internal var uiFrameworkImport: String? { kind.uiFrameworkImport }
    internal var viewControllerType: String { kind.viewControllerType }

    public init(kind: Kind) {
        self.kind = kind
        switch kind {
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
        kind = try decoder.decode("kind")
        let defaults: UIFramework = .init(kind: kind)
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
