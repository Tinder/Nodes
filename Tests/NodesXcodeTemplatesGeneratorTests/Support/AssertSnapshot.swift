// swiftlint:disable:this file_name
//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Foundation
import SnapshotTesting
import XCTest

#if BAZEL
private final class BundleLocator {}
#endif

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
    let testTarget: String = "\(file)".components(separatedBy: "/")[1]
    let bundleURL: URL = Bundle(for: BundleLocator.self)
        .resourceURL!
        .appendingPathComponent("\(testTarget)Snapshots.bundle")
    let resourceURL: URL = Bundle(url: bundleURL)!.resourceURL!
    let absoluteURL: URL = .init(fileURLWithPath: "\(resourceURL.path)/\(file)", isDirectory: false)
    let snapshotDirectory: URL = absoluteURL
        .deletingLastPathComponent()
        .appendingPathComponent("__Snapshots__")
        .appendingPathComponent(absoluteURL.deletingPathExtension().lastPathComponent)
    failure = verifySnapshot(
        of: try value(),
        as: snapshotting,
        named: name,
        record: recording,
        snapshotDirectory: snapshotDirectory.path,
        timeout: timeout,
        file: "",
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
