//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

import Nimble
@testable import NodesGenerator
import XCTest

final class XcodeTemplateConstantsTests: XCTestCase {

    func testProductName() {
        expect(XcodeTemplateConstants.productName) == "productName"
    }

    func testUsePluginList() {
        expect(XcodeTemplateConstants.usePluginList) == "usePluginList"
    }

    func testPluginListName() {
        expect(XcodeTemplateConstants.pluginListName) == "pluginListName"
    }

    func testVariable() {
        expect(XcodeTemplateConstants.variable("Hello World")) == "___VARIABLE_Hello World___"
    }
}
