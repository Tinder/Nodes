//
//  NodeStencil.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/8/22.
//

import Foundation

public enum NodeStencils {

    case viewOwned(swiftUI: Bool)
    case viewInjected

    public static func get(for kind: NodeStencils) -> [StencilTemplate] {
        switch kind {
        case let .viewOwned(swiftUI):
            return [
                .analytics,
                .builder(swiftUI: swiftUI),
                .context,
                .flow,
                .viewController(swiftUI: swiftUI),
                .worker
            ]
        case .viewInjected:
            return [
                .analytics,
                .builder(swiftUI: false),
                .context,
                .flow,
                .worker
            ]
        }
    }
}
