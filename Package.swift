// swift-tools-version:5.8

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
            from: "4.0.0"),
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
            from: "1.11.0"),
    ],
    targets: [
        .target(
            name: "Nodes",
            plugins: [
                .plugin(name: SwiftLint.plugin),
            ]),
        .target(
            name: "NodesTesting",
            dependencies: [
                .product(name: "NeedleFoundation", package: "needle")
            ],
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
                .copy("Resources/Icons"),
                .copy("Resources/Stencils"),
            ],
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
            plugins: [
                .plugin(name: SwiftLint.plugin),
            ]),
        .testTarget(
            name: "NodesTestingTests",
            dependencies: [
                "NodesTesting",
                "Nimble",
            ],
            plugins: [
                .plugin(name: SwiftLint.plugin),
            ]),
        .testTarget(
            name: "NodesXcodeTemplatesGeneratorTests",
            dependencies: [
                "NodesXcodeTemplatesGenerator",
                "Nimble",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ],
            exclude: ["__Snapshots__"],
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
            url: "https://github.com/realm/SwiftLint/releases/download/0.52.4/SwiftLintBinary-macos.artifactbundle.zip",
            checksum: "8a8095e6235a07d00f34a9e500e7568b359f6f66a249f36d12cd846017a8c6f5"),
    ]
)
