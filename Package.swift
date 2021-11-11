// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "Nodes",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v11),
        .tvOS(.v11),
        .watchOS(.v5),
    ],
    products: [
        .library(
            name: "Nodes",
            targets: ["Nodes"]),
        .library(
            name: "XcodeTemplateGenerator",
            targets: ["XcodeTemplateGeneratorLibrary"]),
        .executable(
            name: "xc-template-generator",
            targets: ["XcodeTemplateGeneratorTool"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            from: "0.3.0"),
        .package(
            url: "git@github.com:TinderApp/Preflight.git",
            from: "0.0.0"),
        .package(
            url: "https://github.com/realm/SwiftLint.git",
            from: "0.43.0"),
        .package(
            url: "https://github.com/JohnSundell/Codextended.git",
            from: "0.3.0"),
        .package(
            url: "https://github.com/jpsim/Yams.git",
            from: "4.0.0"),
        .package(
            url: "https://github.com/stencilproject/Stencil.git",
            from: "0.14.0"),
        .package(
            url: "https://github.com/Quick/Nimble.git",
            from: "9.2.0"),
        .package(
            name: "SnapshotTesting",
            url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
            from: "1.9.0"),
    ],
    targets: [
        .target(
            name: "Nodes",
            dependencies: []),
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
                "SnapshotTesting",
            ],
            exclude: ["__Snapshots__"]),
    ]
)
