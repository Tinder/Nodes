load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")
load("@rules_cc//cc:defs.bzl", "objc_library")

swift_library(
    name = "CwlCatchException",
    srcs = glob(["Sources/CwlCatchException/**/*.swift"]),
    visibility = ["//visibility:public"],
    deps = [
        ":CwlCatchExceptionSupport",
    ],
    defines = ["SWIFT_PACKAGE"],
)

objc_library(
    name = "CwlCatchExceptionSupport",
    includes = ["Sources/CwlCatchExceptionSupport/include"],
    hdrs = glob(["Sources/CwlCatchExceptionSupport/**/*.h"]),
    srcs = glob(["Sources/CwlCatchExceptionSupport/**/*.m"]),
    visibility = ["@CwlCatchException//:__subpackages__"],
)
