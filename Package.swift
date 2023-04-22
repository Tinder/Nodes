// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "Nodes",
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
            url: "https://github.com/realm/SwiftLint.git",
            from: "0.46.0"),
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
            from: "10.0.0"),
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
            from: "1.9.0"),
    ],
    targets: [
        .target(
            name: "Nodes",
            plugins: [
                .plugin(name: "SwiftLintPlugin"),
            ]),
        .target(
            name: "NodesTesting",
            dependencies: [
                .product(name: "NeedleFoundation", package: "needle")
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin"),
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
                .copy("Resources/Templates"),
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin"),
            ]),
        .executableTarget(
            name: "NodesXcodeTemplatesGeneratorExecutable",
            dependencies: [
                "NodesXcodeTemplatesGenerator",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin"),
            ]),
        .testTarget(
            name: "NodesTests",
            dependencies: [
                "Nodes",
                "Nimble",
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin"),
            ]),
        .testTarget(
            name: "NodesTestingTests",
            dependencies: [
                "NodesTesting",
                "Nimble",
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin"),
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
                .plugin(name: "SwiftLintPlugin"),
            ]),
        .plugin(
            name: "SwiftLintPlugin",
            capability: .buildTool(),
            dependencies: [
                "SwiftLintBinary",
            ]),
        .binaryTarget(
            name: "SwiftLintBinary",
            url: "https://github.com/realm/SwiftLint/releases/download/0.51.0/SwiftLintBinary-macos.artifactbundle.zip",
            checksum: "9fbfdf1c2a248469cfbe17a158c5fbf96ac1b606fbcfef4b800993e7accf43ae"),
    ]
)
