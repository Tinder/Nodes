//
//  FileSystem.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Christopher Fuller on 4/25/21.
//

import Foundation

/// @mockable
public protocol FileSystem {

    var libraryURL: URL { get }

    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool) throws
    func write(_ data: Data, to url: URL, atomically: Bool) throws
    func contents(of url: URL) throws -> Data
    func copyItem(at fromURL: URL, to toURL: URL) throws
    func removeItem(at url: URL) throws
    func fileExists(atPath path: String) -> Bool
}

extension FileManager: FileSystem {

    public var libraryURL: URL {
        urls(for: .libraryDirectory, in: .userDomainMask)[0]
    }

    public func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool) throws {
        try createDirectory(at: url, withIntermediateDirectories: createIntermediates, attributes: nil)
    }

    public func write(_ data: Data, to url: URL, atomically: Bool) throws {
        try data.write(to: url, options: atomically ? .atomic : [])
    }

    public func contents(of url: URL) throws -> Data {
        try Data(contentsOf: url)
    }
}
