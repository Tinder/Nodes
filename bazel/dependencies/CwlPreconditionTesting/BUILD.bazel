load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")
load("@rules_cc//cc:defs.bzl", "objc_library")

swift_library(
    name = "CwlPreconditionTesting",
    srcs = glob(["Sources/CwlPreconditionTesting/**/*.swift"]),
    visibility = ["//visibility:public"],
    deps = [
        ":CwlMachBadInstructionHandler",
        "@CwlCatchException",
    ],
    defines = ["SWIFT_PACKAGE"],
)

objc_library(
    name = "CwlMachBadInstructionHandler",
    includes = ["Sources/CwlMachBadInstructionHandler/include"],
    hdrs = glob(["Sources/CwlMachBadInstructionHandler/**/*.h"]),
    srcs = glob([
        "Sources/CwlMachBadInstructionHandler/**/*.c",
        "Sources/CwlMachBadInstructionHandler/**/*.m",
    ]),
    visibility = ["@CwlPreconditionTesting//:__subpackages__"],
)
