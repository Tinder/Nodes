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

    func testNodeTemplateForAppKit() throws {
        try assertSnapshot(matching: NodeTemplate(for: .appKit, config: givenConfig()),
                           as: .dump)
    }

    func testNodeTemplateForUIKit() throws {
        try assertSnapshot(matching: NodeTemplate(for: .uiKit, config: givenConfig()),
                           as: .dump)
    }

    func testNodeTemplateForSwiftUI() throws {
        try assertSnapshot(matching: NodeTemplate(for: .swiftUI, config: givenConfig()),
                           as: .dump)
    }

    func testNodeTemplateForCustomFramework() throws {
        try assertSnapshot(matching: NodeTemplate(for: .custom, config: givenConfig()),
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
