//
//  Copyright © 2024 Tinder (Match Group, LLC)
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
        expect(XcodeTemplateConstants.uiFramework) == "uiFramework"
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
