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
        let description: String = "A wizard-style template picker for creating a Node."
        propertyList = PropertyList(description: description, sortOrder: 0) {
            Option(identifier: "productName",
                   name: "Node name:",
                   description: "The name of the Node")
            Option(identifier: "suffix",
                   name: "Node name suffix:",
                   description: "A suffix to add to the node name when using a PluginList",
                   default: "V1")
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
                   values: ["View-Owned"] + (config.isViewInjectedNodeEnabled ? ["View-Injected"] : []))
            Option(identifier: "UIFrameworkSelection",
                   name: "UI Framework",
                   description: "What UI Framework do you want to use?",
                   type: "popup",
                   default: UIFramework.Kind.uiKit.rawValue,
                   values: config.uiFrameworks.map(\.kind).map(\.rawValue))
        }
        let nodeName: String = "\(config.variable("productName"))\(config.variable("suffix"))"
        variations += try config.uiFrameworks.map {
            NodeWizardTemplate.Variation.pluginList(
                "PluginListView-Owned\($0.kind.rawValue)",
                PluginListNodeTemplate(config: config, pluginListItemName: nodeName),
                PluginNodeTemplate(config: config, pluginName: nodeName),
                .viewOwned(try NodeTemplate(for: $0.kind,
                                            config: config,
                                            nodeName: nodeName,
                                            pluginListName: config.variable("productName")))
            )
        }
        variations += try config.uiFrameworks.map {
            NodeWizardTemplate.Variation.plugin(
                "PluginView-Owned\($0.kind.rawValue)",
                PluginNodeTemplate(config: config),
                .viewOwned(try NodeTemplate(for: $0.kind, config: config))
            )
        }
        variations += try config.uiFrameworks.map {
            NodeWizardTemplate.Variation.builder(
                "BuilderView-Owned\($0.kind.rawValue)",
                .viewOwned(try NodeTemplate(for: $0.kind, config: config))
            )
        }
        guard config.isViewInjectedNodeEnabled else {
            return
        }
        variations += config.uiFrameworks.map {
            NodeWizardTemplate.Variation.pluginList(
                "PluginListView-Injected\($0.kind.rawValue)",
                PluginListNodeTemplate(config: config, pluginListItemName: nodeName),
                PluginNodeTemplate(config: config, pluginName: nodeName),
                .viewInjected(NodeViewInjectedTemplate(config: config, nodeName: nodeName))
            )
        }
        variations += config.uiFrameworks.map {
            NodeWizardTemplate.Variation.plugin(
                "PluginView-Injected\($0.kind.rawValue)",
                PluginNodeTemplate(config: config),
                .viewInjected(NodeViewInjectedTemplate(config: config))
            )
        }
        variations += config.uiFrameworks.map {
            NodeWizardTemplate.Variation.builder(
                "BuilderView-Injected\($0.kind.rawValue)",
                .viewInjected(NodeViewInjectedTemplate(config: config))
            )
        }
    }
}
