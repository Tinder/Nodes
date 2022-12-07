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
            case .swiftUI:
                expect(variation) == .swiftUI
            case .appKit, .uiKit, .custom:
                expect(variation) == .default
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
                expect(stencilTemplate.description) == "Analytics"
            case .builder:
                expect(stencilTemplate.description) == "Builder"
            case .context:
                expect(stencilTemplate.description) == "Context"
            case .flow:
                expect(stencilTemplate.description) == "Flow"
            case .plugin:
                expect(stencilTemplate.description) == "Plugin"
            case .pluginList:
                expect(stencilTemplate.description) == "PluginList"
            case .viewController:
                expect(stencilTemplate.description) == "ViewController"
            case .worker:
                expect(stencilTemplate.description) == "Worker"
            }
        }
    }

    func testFilename() {
        StencilTemplate.allCases.forEach { stencilTemplate in
            switch stencilTemplate {
            case .analytics:
                expect(stencilTemplate.filename) == "Analytics"
            case let .builder(variation):
                expect(stencilTemplate.filename) == "Builder".appending(variation == .swiftUI ? "-SwiftUI" : "")
            case .context:
                expect(stencilTemplate.filename) == "Context"
            case .flow:
                expect(stencilTemplate.filename) == "Flow"
            case .plugin:
                expect(stencilTemplate.filename) == "Plugin"
            case .pluginList:
                expect(stencilTemplate.filename) == "PluginList"
            case let .viewController(variation):
                expect(stencilTemplate.filename) == "ViewController".appending(variation == .swiftUI ? "-SwiftUI" : "")
            case .worker:
                expect(stencilTemplate.filename) == "Worker"
            }
        }
    }

    func testNodeStencils() {
        StencilTemplate.Variation.allCases.forEach { variation in
            for withViewController in [true, false] {
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
