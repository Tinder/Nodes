// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "Nodes",
    platforms: [
        .macOS(.v12),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .executable(
            name: "nodes-code-gen",
            targets: ["NodesCodeGenerator"]),
        .executable(
            name: "nodes-xcode-templates-gen",
            targets: ["NodesXcodeTemplatesGenerator"]),
        .library(
            name: "Nodes",
            targets: ["Nodes"]),
        .library(
            name: "NodesGenerator",
            targets: ["NodesGenerator"]),
        .library(
            name: "NodesTesting",
            targets: ["NodesTesting"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            exact: "1.5.0"),
        .package(
            url: "https://github.com/apple/swift-docc-plugin.git",
            exact: "1.4.2"),
        .package(
            url: "https://github.com/JohnSundell/Codextended.git",
            exact: "0.3.0"),
        .package(
            url: "https://github.com/jpsim/Yams.git",
            exact: "5.1.3"),
        .package(
            url: "https://github.com/stencilproject/Stencil.git",
            exact: "0.15.1"),
        .package(
            url: "https://github.com/uber/needle.git",
            exact: "0.25.1"),
        .package(
            url: "https://github.com/realm/SwiftLint.git",
            exact: "0.56.2"),
        .package(
            url: "https://github.com/Quick/Nimble.git",
            exact: "13.4.0"),
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
            exact: "1.17.4"),
    ],
    targets: [
        .executableTarget(
            name: "NodesCodeGenerator",
            dependencies: [
                "NodesGenerator",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "Sources/Executables/NodesCodeGenerator"),
        .executableTarget(
            name: "NodesXcodeTemplatesGenerator",
            dependencies: [
                "NodesGenerator",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "Sources/Executables/NodesXcodeTemplatesGenerator"),
        .target(
            name: "Nodes"),
        .target(
            name: "NodesGenerator",
            dependencies: [
                "Codextended",
                "Yams",
                "Stencil",
            ],
            resources: [
                .process("Resources"),
            ]),
        .target(
            name: "NodesTesting",
            dependencies: [
                "Nodes",
                .product(name: "NeedleFoundation", package: "needle")
            ]),
        .testTarget(
            name: "NodesTests",
            dependencies: [
                "Nodes",
                "Nimble",
            ]),
        .testTarget(
            name: "NodesGeneratorTests",
            dependencies: [
                "NodesGenerator",
                "Nimble",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
                .product(name: "InlineSnapshotTesting", package: "swift-snapshot-testing"),
            ],
            exclude: [
                "__Snapshots__",
            ]),
        .testTarget(
            name: "NodesTestingTests",
            dependencies: [
                "NodesTesting",
                "Nimble",
            ]),
    ]
)

package.targets.forEach { target in

    target.swiftSettings = [
        .enableExperimentalFeature("StrictConcurrency"),
    ]

    target.plugins = [
        .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint"),
    ]
}
