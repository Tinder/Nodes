// swift-tools-version:5.3

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
    ],
    targets: [
        .target(
            name: "Nodes",
            dependencies: []),
        .target(
            name: "XcodeTemplateGeneratorLibrary",
            dependencies: [],
            resources: [
                .copy("Resources/Icons"),
                .copy("Resources/Templates"),
            ]),
        .testTarget(
            name: "NodesTests",
            dependencies: ["Nodes"]),
    ]
)
