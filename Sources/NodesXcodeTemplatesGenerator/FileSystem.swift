//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Foundation

public protocol FileSystem {

    var libraryURL: URL { get }

    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool) throws
    func write(_ data: Data, to url: URL, atomically: Bool) throws
    func contents(of url: URL) throws -> Data
    func copyItem(at fromURL: URL, to toURL: URL) throws
    func removeItem(at url: URL) throws
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
