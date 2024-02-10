// swift-tools-version:5.9

import PackageDescription

let packageName = "Nodes"

enum SwiftLint {
    static let plugin = "SwiftLintPlugin-\(packageName)"
    static let binary = "SwiftLintBinary-\(packageName)"
}

let package = Package(
    name: packageName,
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(
            name: "Nodes",
            targets: ["Nodes"]),
        .library(
            name: "NodesTesting",
            targets: ["NodesTesting"]),
        .library(
            name: "NodesXcodeTemplatesGenerator",
            targets: ["NodesXcodeTemplatesGenerator"]),
        .executable(
            name: "nodes-xcode-templates-gen",
            targets: ["NodesXcodeTemplatesGeneratorExecutable"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            from: "1.0.0"),
        .package(
            url: "https://github.com/apple/swift-docc-plugin.git",
            from: "1.0.0"),
        .package(
            url: "https://github.com/JohnSundell/Codextended.git",
            from: "0.3.0"),
        .package(
            url: "https://github.com/jpsim/Yams.git",
            from: "5.0.0"),
        .package(
            url: "https://github.com/stencilproject/Stencil.git",
            from: "0.15.0"),
        .package(
            url: "https://github.com/uber/needle.git",
            from: "0.22.0"),
        .package(
            url: "https://github.com/Quick/Nimble.git",
            from: "13.0.0"),
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
            from: "1.15.0"),
    ],
    targets: [
        .target(
            name: "Nodes",
            swiftSettings: .swiftSettings,
            plugins: [
                .plugin(name: SwiftLint.plugin),
            ]),
        .target(
            name: "NodesTesting",
            dependencies: [
                .product(name: "NeedleFoundation", package: "needle")
            ],
            swiftSettings: .swiftSettings,
            plugins: [
                .plugin(name: SwiftLint.plugin),
            ]),
        .target(
            name: "NodesXcodeTemplatesGenerator",
            dependencies: [
                "Codextended",
                "Yams",
                "Stencil",
            ],
            resources: [
                .process("Resources"),
            ],
            swiftSettings: .swiftSettings,
            plugins: [
                .plugin(name: SwiftLint.plugin),
            ]),
        .executableTarget(
            name: "NodesXcodeTemplatesGeneratorExecutable",
            dependencies: [
                "NodesXcodeTemplatesGenerator",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            plugins: [
                .plugin(name: SwiftLint.plugin),
            ]),
        .testTarget(
            name: "NodesTests",
            dependencies: [
                "Nodes",
                "Nimble",
            ],
            swiftSettings: .swiftSettings,
            plugins: [
                .plugin(name: SwiftLint.plugin),
            ]),
        .testTarget(
            name: "NodesTestingTests",
            dependencies: [
                "NodesTesting",
                "Nimble",
            ],
            swiftSettings: .swiftSettings,
            plugins: [
                .plugin(name: SwiftLint.plugin),
            ]),
        .testTarget(
            name: "NodesXcodeTemplatesGeneratorTests",
            dependencies: [
                "NodesXcodeTemplatesGenerator",
                "Nimble",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
                .product(name: "InlineSnapshotTesting", package: "swift-snapshot-testing"),
            ],
            exclude: [
                "__Snapshots__",
            ],
            swiftSettings: .swiftSettings,
            plugins: [
                .plugin(name: SwiftLint.plugin),
            ]),
        .plugin(
            name: SwiftLint.plugin,
            capability: .buildTool(),
            dependencies: [
                .target(name: SwiftLint.binary)
            ],
            path: "Plugins/SwiftLintPlugin"),
        .binaryTarget(
            name: SwiftLint.binary,
            url: "https://github.com/realm/SwiftLint/releases/download/0.54.0/SwiftLintBinary-macos.artifactbundle.zip",
            checksum: "963121d6babf2bf5fd66a21ac9297e86d855cbc9d28322790646b88dceca00f1"),
    ]
)

extension Array where Element == SwiftSetting {

    static var swiftSettings: [SwiftSetting] {
        guard let value: String = Context.environment["SWIFT_STRICT_CONCURRENCY"]
        else { return [] }
        return [.unsafeFlags(["-strict-concurrency=\(value)"])]
    }
}
