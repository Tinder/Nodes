load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "SnapshotTesting",
    srcs = glob(["Sources/SnapshotTesting/**/*.swift"]),
    visibility = ["//visibility:public"],
    copts = ["-suppress-warnings"],
    testonly = True,
)

swift_library(
    name = "InlineSnapshotTesting",
    srcs = glob(["Sources/InlineSnapshotTesting/**/*.swift"]),
    visibility = ["//visibility:public"],
    deps = [
        ":SnapshotTesting",
        "@SwiftSyntax//:SwiftParser",
        "@SwiftSyntax//:SwiftSyntax",
        "@SwiftSyntax//:SwiftSyntaxBuilder",
        ":SwiftSyntax509",
    ],
    testonly = True,
)

# TODO: Remove once SwiftSyntax provides the SwiftSyntax509 library natively.

swift_library(
    name = "SwiftSyntax509",
    srcs = ["Sources/InlineSnapshotTesting/Exports.swift"], # This is a hack since `srcs` cannot be empty.
    visibility = ["//visibility:public"],
    deps = [
        ":SnapshotTesting",
    ],
    testonly = True,
)
