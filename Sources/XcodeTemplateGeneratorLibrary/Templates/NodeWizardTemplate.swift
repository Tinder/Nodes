//
//  NodeWizardTemplate.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 12/23/22.
//

internal struct NodeWizardTemplate {

    internal typealias Config = XcodeTemplates.Config
    internal typealias PropertyList = XcodeTemplatePropertyList
    internal typealias Option = PropertyList.Option

    enum Variation {
        case pluginList(String, PluginListNodeTemplate, PluginNodeTemplate, ViewVariation)
        case plugin(String, PluginNodeTemplate, ViewVariation)
        case builder(String, ViewVariation)
    }

    enum ViewVariation {
        case viewOwned(NodeTemplate)
        case viewInjected(NodeViewInjectedTemplate)

        var template: XcodeTemplate {
            switch self {
            case let .viewOwned(template):
                return template
            case let .viewInjected(template):
                return template
            }
        }
    }

    internal let propertyList: PropertyList
    internal private(set) var variations: [Variation] = []

    internal init(config: Config) throws {
        var wizardConfig: Config = config
        wizardConfig.nodeNameSuffix = config.nodeNameSuffix.isEmpty ? "V1" : config.nodeNameSuffix
        let description: String = "A wizard-style template picker for creating a Node."
        propertyList = PropertyList(description: description, sortOrder: 0) {
            Option(identifier: "productName",
                   name: "Node name:",
                   description: "The name of the Node")
            Option(identifier: "FactoryLayerSelection",
                   name: "Factory Layer",
                   description: "What Node Factory Layer type do you want to use?",
                   type: "popup",
                   default: "PluginList",
                   values: ["PluginList", "Plugin", "Builder"])
            Option(identifier: "ViewSourceSelection",
                   name: "View Source",
                   description: "What is the source of the Node's view?",
                   type: "popup",
                   default: "View-Owned",
                   values: ["View-Owned"] + (wizardConfig.isViewInjectedNodeEnabled ? ["View-Injected"] : []))
            Option(identifier: "UIFrameworkSelection",
                   name: "UI Framework",
                   description: "What UI Framework do you want to use?",
                   type: "popup",
                   default: UIFramework.Kind.uiKit.rawValue,
                   values: wizardConfig.uiFrameworks.map(\.kind).map(\.rawValue))
        }
        let pluginListItemName: String = "\(wizardConfig.variable("productName"))\(wizardConfig.nodeNameSuffix)"
        variations += try wizardConfig.uiFrameworks.map {
            NodeWizardTemplate.Variation.pluginList(
                "PluginListView-Owned\($0.kind.rawValue)",
                PluginListNodeTemplate(config: wizardConfig, pluginListItemName: pluginListItemName),
                PluginNodeTemplate(config: wizardConfig),
                .viewOwned(try NodeTemplate(for: $0.kind, config: wizardConfig))
            )
        }
        variations += try wizardConfig.uiFrameworks.map {
            NodeWizardTemplate.Variation.plugin(
                "PluginView-Owned\($0.kind.rawValue)",
                PluginNodeTemplate(config: wizardConfig),
                .viewOwned(try NodeTemplate(for: $0.kind, config: wizardConfig))
            )
        }
        variations += try wizardConfig.uiFrameworks.map {
            NodeWizardTemplate.Variation.builder(
                "BuilderView-Owned\($0.kind.rawValue)",
                .viewOwned(try NodeTemplate(for: $0.kind, config: wizardConfig))
            )
        }
        guard wizardConfig.isViewInjectedNodeEnabled else {
            return
        }
        variations += wizardConfig.uiFrameworks.map {
            NodeWizardTemplate.Variation.pluginList(
                "PluginListView-Injected\($0.kind.rawValue)",
                PluginListNodeTemplate(config: wizardConfig, pluginListItemName: pluginListItemName),
                PluginNodeTemplate(config: wizardConfig),
                .viewInjected(NodeViewInjectedTemplate(config: wizardConfig))
            )
        }
        variations += wizardConfig.uiFrameworks.map {
            NodeWizardTemplate.Variation.plugin(
                "PluginView-Injected\($0.kind.rawValue)",
                PluginNodeTemplate(config: wizardConfig),
                .viewInjected(NodeViewInjectedTemplate(config: wizardConfig))
            )
        }
        variations += wizardConfig.uiFrameworks.map {
            NodeWizardTemplate.Variation.builder(
                "BuilderView-Injected\($0.kind.rawValue)",
                .viewInjected(NodeViewInjectedTemplate(config: wizardConfig))
            )
        }
    }
}
