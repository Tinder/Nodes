load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "Nimble",
    srcs = glob(["Sources/Nimble/**/*.swift"]),
    visibility = ["//visibility:public"],
    deps = [
        "@CwlPreconditionTesting",
    ],
    defines = ["SWIFT_PACKAGE"],
    testonly = True,
)
