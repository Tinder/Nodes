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
        internal static let nodesImports: Set<String> = ["Nodes"]
        internal static let factoryLayerImports: Set<String> = nodesImports.union(["NeedleFoundation"])
        internal static let baseImports: Set<String> = ["Combine"]
        internal static let businessLogicLayerImports: Set<String> = nodesImports.union(baseImports)
        internal static let viewLayerImports: Set<String> = nodesImports.union(baseImports)

        // swiftlint:disable:next nesting
        internal enum ViewControllerMethodsType {

            case standard(swiftUI: Bool), root(swiftUI: Bool)
        }

        public var includedTemplates: [String]
        public var fileHeader: String
        public var analyticsImports: Set<String>
        public var builderImports: Set<String>
        public var contextImports: Set<String>
        public var flowImports: Set<String>
        public var pluginImports: Set<String>
        public var pluginListImports: Set<String>
        public var stateImports: Set<String>
        public var viewControllerImports: Set<String>
        public var viewControllerImportsSwiftUI: Set<String>
        public var viewStateImports: Set<String>
        public var workerImports: Set<String>
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
        public var viewControllerUpdateComment: String
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
            }
        }

        internal func importsForBuilder(ownsView: Bool) -> Set<String> {
            if ownsView {
                return builderImports.union(Config.baseImports)
            } else {
                return builderImports
            }
        }
    }
}

// swiftlint:disable:next no_grouping_extension
extension XcodeTemplates.Config {

    // swiftlint:disable:next function_body_length
    public init() {
        let nodesImports: Set<String> = XcodeTemplates.Config.nodesImports
        let factoryLayerImports: Set<String> = XcodeTemplates.Config.factoryLayerImports
        let businessLogicLayerImports: Set<String> = XcodeTemplates.Config.businessLogicLayerImports
        let viewLayerImports: Set<String> = XcodeTemplates.Config.viewLayerImports
        includedTemplates = [
            "Node",
            "NodeSwiftUI",
            "NodeViewInjected",
            "PluginListNode",
            "PluginNode",
            "Plugin",
            "Worker"
        ]
        fileHeader = "//___FILEHEADER___"
        analyticsImports = ["Foundation"]
        builderImports = factoryLayerImports
        contextImports = businessLogicLayerImports
        flowImports = nodesImports
        pluginImports = factoryLayerImports
        pluginListImports = factoryLayerImports
        stateImports = nodesImports
        viewControllerImports = viewLayerImports.union(["UIKit"])
        viewControllerImportsSwiftUI = viewLayerImports.union(["SwiftUI"])
        viewStateImports = nodesImports
        workerImports = businessLogicLayerImports
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
        viewControllerUpdateComment = """
            // Add implementation to update the user interface when the view state changes.
            """
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
        analyticsImports =
            (try? decoder.decode("analyticsImports"))
            ?? defaults.analyticsImports
        builderImports =
            (try? decoder.decode("builderImports"))
            ?? defaults.builderImports
        contextImports =
            (try? decoder.decode("contextImports"))
            ?? defaults.contextImports
        flowImports =
            (try? decoder.decode("flowImports"))
            ?? defaults.flowImports
        pluginImports =
            (try? decoder.decode("pluginImports"))
            ?? defaults.pluginImports
        pluginListImports =
            (try? decoder.decode("pluginListImports"))
            ?? defaults.pluginListImports
        stateImports =
            (try? decoder.decode("stateImports"))
            ?? defaults.stateImports
        viewControllerImports =
            (try? decoder.decode("viewControllerImports"))
            ?? defaults.viewControllerImports
        viewControllerImportsSwiftUI =
            (try? decoder.decode("viewControllerImportsSwiftUI"))
            ?? defaults.viewControllerImportsSwiftUI
        viewStateImports =
            (try? decoder.decode("viewStateImports"))
            ?? defaults.viewStateImports
        workerImports =
            (try? decoder.decode("workerImports"))
            ?? defaults.workerImports
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
        viewControllerUpdateComment =
            (try? decoder.decodeString("viewControllerUpdateComment"))
            ?? defaults.viewControllerUpdateComment
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
