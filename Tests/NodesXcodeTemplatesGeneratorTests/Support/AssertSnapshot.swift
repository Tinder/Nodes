//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Foundation
import SnapshotTesting
import XCTest

internal func assertSnapshot<Value, Format>(
    of value: @autoclosure () throws -> Value,
    as snapshotting: Snapshotting<Value, Format>,
    named name: String? = nil,
    record recording: Bool = false,
    timeout: TimeInterval = 5,
    file: StaticString = #filePath,
    testName: String = #function,
    line: UInt = #line
) {
    var snapshotDirectory: URL?
    #if BAZEL
    if let srcRoot: String = ProcessInfo.processInfo.environment["SRCROOT"] {
        let absoluteURL: URL = .init(fileURLWithPath: "\(srcRoot)/\(file)", isDirectory: false)
        let filename: String = absoluteURL.deletingPathExtension().lastPathComponent
        snapshotDirectory = absoluteURL
            .deletingLastPathComponent()
            .appendingPathComponent("__Snapshots__")
            .appendingPathComponent(filename)
    } else {
        snapshotDirectory = nil
    }
    #else
    snapshotDirectory = nil
    #endif
    let failure: String? = verifySnapshot(
        of: try value(),
        as: snapshotting,
        named: name,
        record: recording,
        snapshotDirectory: snapshotDirectory?.path,
        timeout: timeout,
        file: file,
        testName: testName,
        line: line
    )
    guard let message: String = failure
    else { return }
    XCTFail(message, file: file, line: line)
}

internal func assertSnapshots<Value, Format>(
    of value: @autoclosure () throws -> Value,
    as strategies: [String: Snapshotting<Value, Format>],
    record recording: Bool = false,
    timeout: TimeInterval = 5,
    file: StaticString = #filePath,
    testName: String = #function,
    line: UInt = #line
) {
    try? strategies.forEach { name, strategy in
        assertSnapshot(
            of: try value(),
            as: strategy,
            named: name,
            record: recording,
            timeout: timeout,
            file: file,
            testName: testName,
            line: line
        )
    }
}

internal func assertSnapshots<Value, Format>(
    of value: @autoclosure () throws -> Value,
    as strategies: [Snapshotting<Value, Format>],
    record recording: Bool = false,
    timeout: TimeInterval = 5,
    file: StaticString = #filePath,
    testName: String = #function,
    line: UInt = #line
) {
    try? strategies.forEach { strategy in
        assertSnapshot(
            of: try value(),
            as: strategy,
            record: recording,
            timeout: timeout,
            file: file,
            testName: testName,
            line: line
        )
    }
}
