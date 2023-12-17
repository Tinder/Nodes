load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "Stencil",
    srcs = glob(["Sources/Stencil/**/*.swift"]),
    visibility = ["@Nodes//:__subpackages__"],
    deps = [
        "@PathKit",
    ],
)
