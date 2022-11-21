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

    public struct Config: Equatable, Codable {

        // swiftlint:disable:next nesting
        public enum ConfigError: Error, Equatable {
            case uiFrameworkNotDefined(kind: UIFramework.Kind)
        }

        // swiftlint:disable:next nesting
        internal enum ImportsType {

            case nodes, diGraph, viewController(UIFramework)
        }

        public var uiFrameworks: [UIFramework]
        public var isViewInjectedNodeEnabled: Bool
        public var fileHeader: String
        public var baseImports: Set<String>
        public var diGraphImports: Set<String>
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

        public func uiFramework(for kind: UIFramework.Kind) throws -> UIFramework {
            guard let uiFramework: UIFramework = uiFrameworks.first(where: { $0.framework.kind == kind }) else {
                throw ConfigError.uiFrameworkNotDefined(kind: kind)
            }
            return uiFramework
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
            case let .viewController(uiFramework):
                return nodesImports.union([uiFramework.import])
            }
        }
    }
}

// swiftlint:disable:next no_grouping_extension
extension XcodeTemplates.Config {

    // swiftlint:disable:next function_body_length
    public init() {
        uiFrameworks = [UIFramework(framework: .uiKit), UIFramework(framework: .swiftUI)]
        isViewInjectedNodeEnabled = true
        fileHeader = "//___FILEHEADER___"
        baseImports = ["Combine"]
        diGraphImports = ["NeedleFoundation"]
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
        uiFrameworks =
            (try? decoder.decode(CodingKeys.uiFrameworks))
            ?? defaults.uiFrameworks
        isViewInjectedNodeEnabled =
            (try? decoder.decode(CodingKeys.isViewInjectedNodeEnabled))
            ?? defaults.isViewInjectedNodeEnabled
        fileHeader =
            (try? decoder.decodeString(CodingKeys.fileHeader))
            ?? defaults.fileHeader
        baseImports =
            (try? decoder.decode(CodingKeys.baseImports))
            ?? defaults.baseImports
        diGraphImports =
            (try? decoder.decode(CodingKeys.diGraphImports))
            ?? defaults.diGraphImports
        viewControllerViewStateImports =
            (try? decoder.decode(CodingKeys.viewControllerViewStateImports))
            ?? defaults.viewControllerViewStateImports
        dependencies =
            (try? decoder.decode(CodingKeys.dependencies))
            ?? defaults.dependencies
        flowProperties =
            (try? decoder.decode(CodingKeys.flowProperties))
            ?? defaults.flowProperties
        viewControllerType =
            (try? decoder.decodeString(CodingKeys.viewControllerType))
            ?? defaults.viewControllerType
        viewControllableType =
            (try? decoder.decodeString(CodingKeys.viewControllableType))
            ?? defaults.viewControllableType
        viewControllableFlowType =
            (try? decoder.decodeString(CodingKeys.viewControllableFlowType))
            ?? defaults.viewControllableFlowType
        viewControllerSuperParameters =
            (try? decoder.decodeString(CodingKeys.viewControllerSuperParameters))
            ?? defaults.viewControllerSuperParameters
        viewControllerProperties =
            (try? decoder.decodeString(CodingKeys.viewControllerProperties))
            ?? defaults.viewControllerProperties
        viewControllerPropertiesSwiftUI =
            (try? decoder.decodeString(CodingKeys.viewControllerPropertiesSwiftUI))
            ?? defaults.viewControllerPropertiesSwiftUI
        viewControllerMethods =
            (try? decoder.decodeString(CodingKeys.viewControllerMethods))
            ?? defaults.viewControllerMethods
        viewControllerMethodsSwiftUI =
            (try? decoder.decodeString(CodingKeys.viewControllerMethodsSwiftUI))
            ?? defaults.viewControllerMethodsSwiftUI
        rootViewControllerMethods =
            (try? decoder.decodeString(CodingKeys.rootViewControllerMethods))
            ?? defaults.rootViewControllerMethods
        rootViewControllerMethodsSwiftUI =
            (try? decoder.decodeString(CodingKeys.rootViewControllerMethodsSwiftUI))
            ?? defaults.rootViewControllerMethodsSwiftUI
        viewControllerWithoutViewStateMethods =
            (try? decoder.decodeString(CodingKeys.viewControllerWithoutViewStateMethods))
            ?? defaults.viewControllerWithoutViewStateMethods
        viewControllerWithoutViewStateMethodsSwiftUI =
            (try? decoder.decodeString(CodingKeys.viewControllerWithoutViewStateMethodsSwiftUI))
            ?? defaults.viewControllerWithoutViewStateMethodsSwiftUI
        viewControllerUpdateComment =
            (try? decoder.decodeString(CodingKeys.viewControllerUpdateComment))
            ?? defaults.viewControllerUpdateComment
        viewStatePublisher =
            (try? decoder.decodeString(CodingKeys.viewStatePublisher))
            ?? defaults.viewStatePublisher
        viewStateOperators =
            (try? decoder.decodeString(CodingKeys.viewStateOperators))
            ?? defaults.viewStateOperators
        publisherType =
            (try? decoder.decodeString(CodingKeys.publisherType))
            ?? defaults.publisherType
        publisherFailureType =
            (try? decoder.decodeString(CodingKeys.publisherFailureType))
            ?? defaults.publisherFailureType
        cancellableType =
            (try? decoder.decodeString(CodingKeys.cancellableType))
            ?? defaults.cancellableType
    }
}
