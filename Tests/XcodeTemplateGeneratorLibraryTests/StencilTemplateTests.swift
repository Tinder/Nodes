//
//  StencilTemplateTests.swift
//  XcodeTemplateGeneratorLibraryTests
//
//  Created by Garric Nahapetian on 11/4/22.
//

import XcodeTemplateGeneratorLibrary
import XCTest

final class StencilTemplateTests: XCTestCase {

    func testRawValue() {
        XCTAssertEqual(StencilTemplate.analytics.rawValue, "Analytics")
        XCTAssertEqual(StencilTemplate.builder.rawValue, "Builder")
        XCTAssertEqual(StencilTemplate.builderSwiftUI.rawValue, "Builder-SwiftUI")
        XCTAssertEqual(StencilTemplate.context.rawValue, "Context")
        XCTAssertEqual(StencilTemplate.flow.rawValue, "Flow")
        XCTAssertEqual(StencilTemplate.plugin.rawValue, "Plugin")
        XCTAssertEqual(StencilTemplate.pluginList.rawValue, "PluginList")
        XCTAssertEqual(StencilTemplate.viewController.rawValue, "ViewController")
        XCTAssertEqual(StencilTemplate.viewControllerSwiftUI.rawValue, "ViewController-SwiftUI")
        XCTAssertEqual(StencilTemplate.worker.rawValue, "Worker")
    }
}
