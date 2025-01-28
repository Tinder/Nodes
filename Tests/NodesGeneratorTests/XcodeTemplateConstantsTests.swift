//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

import Nimble
@testable import NodesGenerator
import XCTest

final class XcodeTemplateConstantsTests: XCTestCase {

    func testFileBaseName() {
        expect(XcodeTemplateConstants.fileBaseName) == "___FILEBASENAME___"
    }

    func testFileHeader() {
        expect(XcodeTemplateConstants.fileHeader) == "___FILEHEADER___"
    }

    func testProductName() {
        expect(XcodeTemplateConstants.productName) == "productName"
    }

    func testUIFramework() {
        expect(XcodeTemplateConstants.uiFramework) == "UIFramework"
    }

    func testCreatedForPluginList() {
        expect(XcodeTemplateConstants.createdForPluginList) == "CreatedForPluginList"
    }

    func testPluginListName() {
        expect(XcodeTemplateConstants.pluginListName) == "PluginListName"
    }

    func testVariable() {
        expect(XcodeTemplateConstants.variable("Hello World")) == "___VARIABLE_Hello World___"
    }
}
