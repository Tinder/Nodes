load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "ArgumentParser",
    srcs = glob(["Sources/ArgumentParser/**/*.swift"]),
    visibility = ["@Nodes//:__subpackages__"],
    deps = [
        "@ArgumentParser//:ArgumentParserToolInfo",
    ],
)

swift_library(
    name = "ArgumentParserToolInfo",
    srcs = glob(["Sources/ArgumentParserToolInfo/**/*.swift"]),
    visibility = ["@ArgumentParser//:__subpackages__"],
)
