//
//  TemplatesTests.swift
//  XcodeTemplateGeneratorLibraryTests
//
//  Created by Christopher Fuller on 5/31/21.
//

import SnapshotTesting
@testable import XcodeTemplateGeneratorLibrary
import XCTest

final class TemplatesTests: XCTestCase, TestFactories {

    func testNodeTemplate() {
        assertSnapshot(matching: NodeTemplate(config: givenConfig(), uiFramework: .UIKit),
                       as: .dump)
    }

    func testNodeSwiftUITemplate() {
        assertSnapshot(matching: NodeTemplate(config: givenConfig(), uiFramework: .SwiftUI),
                       as: .dump)
    }

    func testNodeViewInjectedTemplate() {
        assertSnapshot(matching: NodeViewInjectedTemplate(config: givenConfig()),
                       as: .dump)
    }

    func testPluginListNodeTemplate() {
        assertSnapshot(matching: PluginListNodeTemplate(config: givenConfig()),
                       as: .dump)
    }

    func testPluginNodeTemplate() {
        assertSnapshot(matching: PluginNodeTemplate(config: givenConfig()),
                       as: .dump)
    }

    func testPluginTemplate() {
        assertSnapshot(matching: PluginTemplate(config: givenConfig()),
                       as: .dump)
    }

    func testWorkerTemplate() {
        assertSnapshot(matching: WorkerTemplate(config: givenConfig()),
                       as: .dump)
    }
}
