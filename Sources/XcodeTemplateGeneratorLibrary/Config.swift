//
//  Config.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Christopher Fuller on 6/3/21.
//

import Codextended
import Foundation
import Yams

extension XcodeTemplates {

    public struct Config: Equatable, Decodable {

        internal static let symbolForSwiftUI: String = ""

        // swiftlint:disable:next nesting
        internal enum ImportsType {

            case nodes, diGraph, viewController(UIFramework)
        }

        public var uiFrameworks: [UIFramework]
        public var isViewInjectedNodeEnabled: Bool
        public var fileHeader: String
        public var baseImports: Set<String>
        public var diGraphImports: Set<String>
        public var dependencies: [Variable]
        public var flowProperties: [Variable]
        public var viewControllableType: String
        public var viewControllableFlowType: String
        public var viewControllerUpdateComment: String
        public var viewStatePublisher: String
        public var viewStateOperators: String
        public var publisherType: String
        public var publisherFailureType: String
        public var cancellableType: String

        public init(
            at path: String,
            using fileSystem: FileSystem = FileManager.default
        ) throws {
            let url: URL = .init(fileURLWithPath: path)
            self = try fileSystem.contents(of: url).decoded(using: YAMLDecoder())
        }

        internal func variable(_ name: String) -> String {
            "___VARIABLE_\(name)___"
        }

        internal func imports(for type: ImportsType) -> Set<String> {
            let nodesImports: Set<String> = baseImports.union(["Nodes"])
            switch type {
            case .nodes:
                return nodesImports
            case .diGraph:
                return nodesImports.union(diGraphImports)
            case let .viewController(framework):
                return nodesImports.union([framework.uiFrameworkImport])
            }
        }

        internal func uiFramework(for kind: UIFramework.Kind) -> UIFramework? {
            uiFrameworks.first { $0.kind == kind }
        }
    }
}

// swiftlint:disable:next no_grouping_extension
extension XcodeTemplates.Config {

    // swiftlint:disable:next function_body_length
    public init() {
        uiFrameworks = [.uiKit(options: Self.uiKitOptions()), .swiftUI(options: Self.swiftUIOptions())]
        isViewInjectedNodeEnabled = true
        fileHeader = "//___FILEHEADER___"
        baseImports = ["Combine"]
        diGraphImports = ["NeedleFoundation"]
        dependencies = []
        flowProperties = []
        viewControllableType = "ViewControllable"
        viewControllableFlowType = "ViewControllableFlow"
        viewControllerUpdateComment = """
            // Add implementation to update the user interface when the view state changes.
            """
        viewStatePublisher = "Just(.initialState).eraseToAnyPublisher()"
        viewStateOperators = """
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            """
        publisherType = "AnyPublisher"
        publisherFailureType = ", Never"
        cancellableType = "AnyCancellable"
    }

    private static func appKitOptions() -> UIFramework.Options {
        UIFramework.Options(
            viewControllerSuperParameters: "",
            viewControllerProperties: "",
            viewControllerMethods: "",
            viewControllerMethodsForRootNode: ""
        )
    }

    private static func uiKitOptions() -> UIFramework.Options {
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

    private static func swiftUIOptions() -> UIFramework.Options {
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

// swiftlint:disable:next no_grouping_extension
extension XcodeTemplates.Config {

    // swiftlint:disable:next function_body_length
    public init(from decoder: Decoder) throws {
        let defaults: XcodeTemplates.Config = .init()
        uiFrameworks =
            (try? decoder.decode("uiFrameworks"))
            ?? defaults.uiFrameworks
        isViewInjectedNodeEnabled =
            (try? decoder.decode("isViewInjectedNodeEnabled"))
            ?? defaults.isViewInjectedNodeEnabled
        fileHeader =
            (try? decoder.decodeString("fileHeader"))
            ?? defaults.fileHeader
        baseImports =
            (try? decoder.decode("baseImports"))
            ?? defaults.baseImports
        diGraphImports =
            (try? decoder.decode("diGraphImports"))
            ?? defaults.diGraphImports
        dependencies =
            (try? decoder.decode("dependencies"))
            ?? defaults.dependencies
        flowProperties =
            (try? decoder.decode("flowProperties"))
            ?? defaults.flowProperties
        viewControllableType =
            (try? decoder.decodeString("viewControllableType"))
            ?? defaults.viewControllableType
        viewControllableFlowType =
            (try? decoder.decodeString("viewControllableFlowType"))
            ?? defaults.viewControllableFlowType
        viewControllerUpdateComment =
            (try? decoder.decodeString("viewControllerUpdateComment"))
            ?? defaults.viewControllerUpdateComment
        viewStatePublisher =
            (try? decoder.decodeString("viewStatePublisher"))
            ?? defaults.viewStatePublisher
        viewStateOperators =
            (try? decoder.decodeString("viewStateOperators"))
            ?? defaults.viewStateOperators
        publisherType =
            (try? decoder.decodeString("publisherType"))
            ?? defaults.publisherType
        publisherFailureType =
            (try? decoder.decodeString("publisherFailureType"))
            ?? defaults.publisherFailureType
        cancellableType =
            (try? decoder.decodeString("cancellableType"))
            ?? defaults.cancellableType
    }
}

extension YAMLDecoder: AnyDecoder {}

extension Decoder {

    // Workaround for https://github.com/jpsim/Yams/issues/301
    internal func decodeString(_ key: String) throws -> String {
        try decode(key, as: String.self)
    }
}
