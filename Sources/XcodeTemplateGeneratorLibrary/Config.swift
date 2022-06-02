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

            case nodes, diGraph, viewController(viewState: Bool, swiftUI: Bool)
        }

        // swiftlint:disable:next nesting
        internal enum ViewControllerMethodsType {

            case standard(swiftUI: Bool), root(swiftUI: Bool), withoutViewState(swiftUI: Bool)
        }

        public var includedTemplates: [String]
        public var fileHeader: String
        public var baseImports: Set<String>
        public var diGraphImports: Set<String>
        public var viewControllerImports: Set<String>
        public var viewControllerImportsSwiftUI: Set<String>
        public var viewControllerViewStateImports: Set<String>
        public var dependencies: [Variable]
        public var flowProperties: [Variable]
        public var viewControllerType: String
        public var viewControllableType: String
        public var viewControllableFlowType: String
        public var viewControllerSuperParameters: String
        public var viewControllerProperties: String
        public var viewControllerPropertiesSwiftUI: String
        public var viewControllerMethods: String
        public var viewControllerMethodsSwiftUI: String
        public var rootViewControllerMethods: String
        public var rootViewControllerMethodsSwiftUI: String
        public var viewControllerWithoutViewStateMethods: String
        // swiftlint:disable:next identifier_name
        public var viewControllerWithoutViewStateMethodsSwiftUI: String
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
            case let .viewController(viewState, swiftUI):
                let imports: Set<String> = swiftUI
                    ? nodesImports.union(viewControllerImportsSwiftUI)
                    : nodesImports.union(viewControllerImports)
                return viewState ? imports.union(viewControllerViewStateImports) : imports
            }
        }

        internal func viewControllerProperties(swiftUI: Bool = false) -> String {
            swiftUI ? viewControllerPropertiesSwiftUI : viewControllerProperties
        }

        internal func viewControllerMethods(for type: ViewControllerMethodsType) -> String {
            switch type {
            case let .standard(swiftUI):
                return swiftUI
                    ? viewControllerMethodsSwiftUI
                    : viewControllerMethods
            case let .root(swiftUI):
                return swiftUI
                    ? rootViewControllerMethodsSwiftUI
                    : rootViewControllerMethods
            case let .withoutViewState(swiftUI):
                return swiftUI
                    ? viewControllerWithoutViewStateMethodsSwiftUI
                    : viewControllerWithoutViewStateMethods
            }
        }
    }
}

// swiftlint:disable:next no_grouping_extension
extension XcodeTemplates.Config {

    // swiftlint:disable:next function_body_length
    public init() {
        includedTemplates = [
            "Node",
            "NodeSwiftUI",
            "NodeWithoutViewState",
            "NodeWithoutViewStateSwiftUI",
            "NodeViewInjected",
            "PluginListNode",
            "PluginMapNode",
            "PluginNode",
            "Plugin",
            "Worker"
        ]
        fileHeader = "//___FILEHEADER___"
        baseImports = ["Combine"]
        diGraphImports = ["NeedleFoundation"]
        viewControllerImports = ["UIKit"]
        viewControllerImportsSwiftUI = ["SwiftUI"]
        viewControllerViewStateImports = []
        dependencies = []
        flowProperties = []
        viewControllerType = "UIViewController"
        viewControllableType = "ViewControllable"
        viewControllableFlowType = "ViewControllableFlow"
        viewControllerSuperParameters = "nibName: nil, bundle: nil"
        viewControllerProperties = ""
        viewControllerPropertiesSwiftUI = ""
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
        viewControllerMethodsSwiftUI = ""
        rootViewControllerMethods = """
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
        rootViewControllerMethodsSwiftUI = """
            override func viewDidAppear(_ animated: Bool) {
                super.viewDidAppear(animated)
                receiver?.viewDidAppear()
            }
            """
        viewControllerWithoutViewStateMethods = """
            override func viewDidLoad() {
                super.viewDidLoad()
                view.backgroundColor = .systemBackground
            }
            """
        viewControllerWithoutViewStateMethodsSwiftUI = ""
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
}

// swiftlint:disable:next no_grouping_extension
extension XcodeTemplates.Config {

    // swiftlint:disable:next function_body_length
    public init(from decoder: Decoder) throws {
        let defaults: XcodeTemplates.Config = .init()
        includedTemplates =
            (try? decoder.decode("includedTemplates"))
            ?? defaults.includedTemplates
        fileHeader =
            (try? decoder.decodeString("fileHeader"))
            ?? defaults.fileHeader
        baseImports =
            (try? decoder.decode("baseImports"))
            ?? defaults.baseImports
        diGraphImports =
            (try? decoder.decode("diGraphImports"))
            ?? defaults.diGraphImports
        viewControllerImports =
            (try? decoder.decode("viewControllerImports"))
            ?? defaults.viewControllerImports
        viewControllerImportsSwiftUI =
            (try? decoder.decode("viewControllerImportsSwiftUI"))
            ?? defaults.viewControllerImportsSwiftUI
        viewControllerViewStateImports =
            (try? decoder.decode("viewControllerViewStateImports"))
            ?? defaults.viewControllerViewStateImports
        dependencies =
            (try? decoder.decode("dependencies"))
            ?? defaults.dependencies
        flowProperties =
            (try? decoder.decode("flowProperties"))
            ?? defaults.flowProperties
        viewControllerType =
            (try? decoder.decodeString("viewControllerType"))
            ?? defaults.viewControllerType
        viewControllableType =
            (try? decoder.decodeString("viewControllableType"))
            ?? defaults.viewControllableType
        viewControllableFlowType =
            (try? decoder.decodeString("viewControllableFlowType"))
            ?? defaults.viewControllableFlowType
        viewControllerSuperParameters =
            (try? decoder.decodeString("viewControllerSuperParameters"))
            ?? defaults.viewControllerSuperParameters
        viewControllerProperties =
            (try? decoder.decodeString("viewControllerProperties"))
            ?? defaults.viewControllerProperties
        viewControllerPropertiesSwiftUI =
            (try? decoder.decodeString("viewControllerPropertiesSwiftUI"))
            ?? defaults.viewControllerPropertiesSwiftUI
        viewControllerMethods =
            (try? decoder.decodeString("viewControllerMethods"))
            ?? defaults.viewControllerMethods
        viewControllerMethodsSwiftUI =
            (try? decoder.decodeString("viewControllerMethodsSwiftUI"))
            ?? defaults.viewControllerMethodsSwiftUI
        rootViewControllerMethods =
            (try? decoder.decodeString("rootViewControllerMethods"))
            ?? defaults.rootViewControllerMethods
        rootViewControllerMethodsSwiftUI =
            (try? decoder.decodeString("rootViewControllerMethodsSwiftUI"))
            ?? defaults.rootViewControllerMethodsSwiftUI
        viewControllerWithoutViewStateMethods =
            (try? decoder.decodeString("viewControllerWithoutViewStateMethods"))
            ?? defaults.viewControllerWithoutViewStateMethods
        viewControllerWithoutViewStateMethodsSwiftUI =
            (try? decoder.decodeString("viewControllerWithoutViewStateMethodsSwiftUI"))
            ?? defaults.viewControllerWithoutViewStateMethodsSwiftUI
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
