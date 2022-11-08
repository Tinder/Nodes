//
//  NodeStencil.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/8/22.
//

import Foundation

public enum NodeStencils {

    case viewOwned(UIFramework)
    case viewInjected

    public static func get(for kind: NodeStencils) -> [StencilTemplate] {
        switch kind {
        case let .viewOwned(uiFramework):
            return [
                .analytics,
                .builder(uiFramework),
                .context,
                .flow,
                .viewController(uiFramework),
                .worker
            ]
        case .viewInjected:
            return [
                .analytics,
                .builder(.None),
                .context,
                .flow,
                .worker
            ]
        }
    }
}
