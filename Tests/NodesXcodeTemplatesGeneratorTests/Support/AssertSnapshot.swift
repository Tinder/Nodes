//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

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
    let failure: String?
    #if BAZEL
    let runfilesPath: String = ProcessInfo.processInfo.environment["TEST_SRCDIR"]!
    let workspaceName: String = ProcessInfo.processInfo.environment["TEST_WORKSPACE"]!
    let testCase: URL = .init(fileURLWithPath: "\(runfilesPath)/\(workspaceName)/\(file)", isDirectory: false)
    let snapshotDirectory: URL = testCase
        .deletingLastPathComponent()
        .appendingPathComponent("__Snapshots__")
        .appendingPathComponent(testCase.deletingPathExtension().lastPathComponent)
    failure = verifySnapshot(
        of: try value(),
        as: snapshotting,
        named: name,
        record: recording,
        snapshotDirectory: snapshotDirectory.path,
        timeout: timeout,
        file: StaticString(), // <- Intentionally avoiding possibility of invalid relative path usage.
        testName: testName,
        line: line
    )
    #else
    failure = verifySnapshot(
        of: try value(),
        as: snapshotting,
        named: name,
        record: recording,
        timeout: timeout,
        file: file,
        testName: testName,
        line: line
    )
    #endif
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
