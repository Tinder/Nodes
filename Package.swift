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
            name: "XcodeTemplateGenerator",
            targets: ["XcodeTemplateGeneratorLibrary"]),
        .executable(
            name: "xc-template-generator",
            targets: ["XcodeTemplateGeneratorTool"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            from: "1.0.0"),
        .package(
            url: "https://github.com/apple/swift-docc-plugin.git",
            from: "1.0.0"),
        .package(
            url: "git@github.com:TinderApp/Preflight.git",
            from: "0.0.0"),
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
            url: "https://github.com/Quick/Nimble.git",
            from: "10.0.0"),
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
            from: "1.9.0"),
        .package(
            url: "https://github.com/uber/needle.git",
            from: "0.19.0"),
    ],
    targets: [
        .target(
            name: "Nodes",
            dependencies: []),
        .target(
            name: "NodesTesting",
            dependencies: [
                .product(name: "NeedleFoundation", package: "needle")
            ]),
        .target(
            name: "XcodeTemplateGeneratorLibrary",
            dependencies: [
                "Codextended",
                "Yams",
                "Stencil",
            ],
            resources: [
                .copy("Resources/Icons"),
                .copy("Resources/Templates"),
            ]),
        .executableTarget(
            name: "XcodeTemplateGeneratorTool",
            dependencies: [
                "XcodeTemplateGeneratorLibrary",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .testTarget(
            name: "NodesTests",
            dependencies: [
                "Nodes",
                "Nimble",
            ]),
        .testTarget(
            name: "XcodeTemplateGeneratorLibraryTests",
            dependencies: [
                "XcodeTemplateGeneratorLibrary",
                "Nimble",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ],
            exclude: ["__Snapshots__"]),
    ]
)
