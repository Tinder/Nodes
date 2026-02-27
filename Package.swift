// swift-tools-version:5.10

import Foundation
import PackageDescription

let environment = ProcessInfo.processInfo.environment

let treatWarningsAsErrors = environment["CI"] == "true"
let enableSwiftLintBuildToolPlugin = environment["CODEQL_DIST"] == nil

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
            exact: "1.7.0"),
        .package(
            url: "https://github.com/apple/swift-docc-plugin.git",
            exact: "1.4.5"),
        .package(
            url: "https://github.com/JohnSundell/Codextended.git",
            exact: "0.3.0"),
        .package(
            url: "https://github.com/jpsim/Yams.git",
            exact: "5.4.0"),
        .package(
            url: "https://github.com/stencilproject/Stencil.git",
            exact: "0.15.1"),
        .package(
            url: "https://github.com/uber/needle.git",
            exact: "0.25.1"),
        .package(
            url: "https://github.com/realm/SwiftLint.git",
            exact: "0.59.1"),
        .package(
            url: "https://github.com/Quick/Nimble.git",
            exact: "14.0.0"),
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
            exact: "1.18.9"),
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

    let types: [Target.TargetType] = [
        .regular,
        .test,
        .executable,
    ]

    guard types.contains(target.type)
    else { return }

    target.swiftSettings = (target.swiftSettings ?? []) + [.enableExperimentalFeature("StrictConcurrency")]

//    if treatWarningsAsErrors {
//        target.swiftSettings = (target.swiftSettings ?? []) + [
//            .treatAllWarnings(as: .error),
//            .treatWarning("DeprecatedDeclaration", as: .warning),
//        ]
//    }

    if enableSwiftLintBuildToolPlugin {
        target.plugins = (target.plugins ?? []) + [
            .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint"),
        ]
    }
}
