//
//  StencilTemplateTests.swift
//  XcodeTemplateGeneratorLibraryTests
//
//  Created by Garric Nahapetian on 12/6/22.
//

import Nimble
@testable import XcodeTemplateGeneratorLibrary
import XCTest

final class StencilTemplateTests: XCTestCase {

    func testVariationRawValue() {
        StencilTemplate.Variation.allCases.forEach { variation in
            switch variation {
            case .default:
                expect(variation.rawValue) == ""
            case .swiftUI:
                expect(variation.rawValue) == "-SwiftUI"
            }
        }
    }

    func testVariationForKind() {
        UIFramework.Kind.allCases.forEach { uiFrameworkKind in
            let variation: StencilTemplate.Variation = .variation(for: uiFrameworkKind)
            switch uiFrameworkKind {
            case .appKit, .uiKit, .custom:
                expect(variation) == .default
            case .swiftUI:
                expect(variation) == .swiftUI
            }
        }
    }

    func testAllCases() {
        expect(StencilTemplate.allCases) == [
            .analytics,
            .builder(.default),
            .builder(.swiftUI),
            .context,
            .flow,
            .plugin,
            .pluginList,
            .viewController(.default),
            .viewController(.swiftUI),
            .worker
        ]
    }

    func testDescription() {
        StencilTemplate.allCases.forEach { stencilTemplate in
            switch stencilTemplate {
            case .analytics:
                expect("\(stencilTemplate)") == "Analytics"
            case .builder:
                expect("\(stencilTemplate)") == "Builder"
            case .context:
                expect("\(stencilTemplate)") == "Context"
            case .flow:
                expect("\(stencilTemplate)") == "Flow"
            case .plugin:
                expect("\(stencilTemplate)") == "Plugin"
            case .pluginList:
                expect("\(stencilTemplate)") == "PluginList"
            case .viewController:
                expect("\(stencilTemplate)") == "ViewController"
            case .worker:
                expect("\(stencilTemplate)") == "Worker"
            }
        }
    }

    func testFilename() {
        StencilTemplate.allCases.forEach { stencilTemplate in
            switch stencilTemplate {
            case .analytics:
                expect(stencilTemplate.filename) == "Analytics"
            case let .builder(variation):
                expect(stencilTemplate.filename) == "Builder\(variation == .swiftUI ? "-SwiftUI" : "")"
            case .context:
                expect(stencilTemplate.filename) == "Context"
            case .flow:
                expect(stencilTemplate.filename) == "Flow"
            case .plugin:
                expect(stencilTemplate.filename) == "Plugin"
            case .pluginList:
                expect(stencilTemplate.filename) == "PluginList"
            case let .viewController(variation):
                expect(stencilTemplate.filename) == "ViewController\(variation == .swiftUI ? "-SwiftUI" : "")"
            case .worker:
                expect(stencilTemplate.filename) == "Worker"
            }
        }
    }

    func testNodeStencils() {
        StencilTemplate.Variation.allCases.forEach { variation in
            for withViewController: Bool in [true, false] {
                let stencils: [StencilTemplate] = StencilTemplate.nodeStencils(for: variation,
                                                                               withViewController: withViewController)
                if withViewController {
                    expect(stencils) == [
                        .analytics,
                        .builder(variation),
                        .context,
                        .flow,
                        .viewController(variation),
                        .worker
                    ]
                } else {
                    expect(stencils) == [
                        .analytics,
                        .builder(variation),
                        .context,
                        .flow,
                        .worker
                    ]
                }
            }
        }
    }
}
