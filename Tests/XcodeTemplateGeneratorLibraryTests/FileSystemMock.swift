//
//  FileSystemMock.swift
//  XcodeTemplateGeneratorLibraryTests
//
//  Created by Christopher Fuller on 6/1/21.
//

import Foundation
import XcodeTemplateGeneratorLibrary

internal final class FileSystemMock: FileSystem {

    internal var contents: [URL: Data] = [:]

    internal private(set) var directories: [(path: String, createIntermediates: Bool)] = []
    // swiftlint:disable:next large_tuple
    internal private(set) var writes: [(contents: String, path: String, atomically: Bool)] = []
    internal private(set) var copies: [(from: String, to: String)] = []
    internal private(set) var deletions: [String] = []

    internal let libraryURL: URL = .init(fileURLWithPath: "/")

    internal func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool) throws {
        directories.append((path: url.path, createIntermediates: createIntermediates))
    }

    internal func write(_ data: Data, to url: URL, atomically: Bool) throws {
        let contents: String = .init(decoding: data, as: UTF8.self)
        writes.append((contents: contents, path: url.path, atomically: atomically))
    }

    internal func contents(of url: URL) throws -> Data {
        contents[url] ?? Data()
    }

    internal func copyItem(at fromURL: URL, to toURL: URL) throws {
        let path: String = fromURL.path.replacingOccurrences(of: "/Contents/Resources", with: "")
        let bundle: String = "Nodes_XcodeTemplateGeneratorLibrary"
        copies.append((from: path.components(separatedBy: bundle).last!, to: toURL.path))
    }

    internal func removeItem(at url: URL) throws {
        deletions.append(url.path)
    }
}
