//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

#if os(macOS)

import Nimble
import NodesGenerator
import XCTest

final class FileSystemTests: XCTestCase {

    private let fileManager: FileManager = .default

    func testLibraryURL() {
        let fileSystem: FileSystem = fileManager
        let libraryURL: URL = fileManager.homeDirectoryForCurrentUser.appendingPathComponent("Library")
        expect(fileSystem.libraryURL) == libraryURL
    }

    func testCreateDirectory() throws {
        let fileSystem: FileSystem = fileManager
        let url: URL = try fileManager
            .url(for: .itemReplacementDirectory,
                 in: .userDomainMask,
                 appropriateFor: fileSystem.libraryURL,
                 create: true)
            .appendingPathComponent("directory")
        expect(try fileSystem.createDirectory(at: url, withIntermediateDirectories: false)).toNot(throwAssertion())
    }

    func testWriteAndContents() throws {
        let fileSystem: FileSystem = fileManager
        let url: URL = try fileManager
            .url(for: .itemReplacementDirectory,
                 in: .userDomainMask,
                 appropriateFor: fileSystem.libraryURL,
                 create: true)
        let file1: URL = url.appendingPathComponent("file1")
        let file2: URL = url.appendingPathComponent("file2")
        let contents: Data = .init("data".utf8)
        expect(try fileSystem.write(contents, to: file1, atomically: false)).toNot(throwAssertion())
        expect(try fileSystem.write(contents, to: file2, atomically: true)).toNot(throwAssertion())
        expect(try fileSystem.contents(of: file1)) == contents
        expect(try fileSystem.contents(of: file2)) == contents
    }
}

#endif
