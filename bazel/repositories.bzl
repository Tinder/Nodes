load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def nodes_dependencies():

    ARGUMENTPARSER_VERSION = "1.3.0"
    ARGUMENTPARSER_SHA_256 = "e5010ff37b542807346927ba68b7f06365a53cf49d36a6df13cef50d86018204"

    maybe(
        http_archive,
        name = "ArgumentParser",
        url = "https://github.com/apple/swift-argument-parser/archive/refs/tags/%s.tar.gz" % ARGUMENTPARSER_VERSION,
        strip_prefix = "swift-argument-parser-%s" % ARGUMENTPARSER_VERSION,
        sha256 = ARGUMENTPARSER_SHA_256,
        build_file = "@nodes_architecture_framework//bazel:dependencies/ArgumentParser/BUILD",
    )

    CODEXTENDED_VERSION = "0.3.0"
    CODEXTENDED_SHA_256 = "2e1195354ede4ca9c4751d910ac0ec84b60ebae4dae22aee3a663b91ea7c81a7"

    maybe(
        http_archive,
        name = "Codextended",
        url = "https://github.com/JohnSundell/Codextended/archive/refs/tags/%s.tar.gz" % CODEXTENDED_VERSION,
        strip_prefix = "Codextended-%s" % CODEXTENDED_VERSION,
        sha256 = CODEXTENDED_SHA_256,
        build_file = "@nodes_architecture_framework//bazel:dependencies/Codextended/BUILD",
    )

    CWLCATCHEXCEPTION_VERSION = "2.1.2"
    CWLCATCHEXCEPTION_SHA_256 = "bae8844e8ebf92972689f4ff872971d162e9b1bddd1c6445ca5cd81546efde19"

    maybe(
        http_archive,
        name = "CwlCatchException",
        url = "https://github.com/mattgallagher/CwlCatchException/archive/refs/tags/%s.tar.gz" % CWLCATCHEXCEPTION_VERSION,
        strip_prefix = "CwlCatchException-%s" % CWLCATCHEXCEPTION_VERSION,
        sha256 = CWLCATCHEXCEPTION_SHA_256,
        build_file = "@nodes_architecture_framework//bazel:dependencies/CwlCatchException/BUILD",
    )

    CWLPRECONDITIONTESTING_VERSION = "2.2.0"
    CWLPRECONDITIONTESTING_SHA_256 = "2236cbdef60df5a0396af29ee9c187576f2e5f4383ff340000f04f30bf1bdd9e"

    maybe(
        http_archive,
        name = "CwlPreconditionTesting",
        url = "https://github.com/mattgallagher/CwlPreconditionTesting/archive/refs/tags/%s.tar.gz" % CWLPRECONDITIONTESTING_VERSION,
        strip_prefix = "CwlPreconditionTesting-%s" % CWLPRECONDITIONTESTING_VERSION,
        sha256 = CWLPRECONDITIONTESTING_SHA_256,
        build_file = "@nodes_architecture_framework//bazel:dependencies/CwlPreconditionTesting/BUILD",
    )

    NEEDLE_VERSION = "0.24.0"
    NEEDLE_SHA_256 = "61b7259a369d04d24c0c532ecf3295fdff92e79e4d0f96abaed1552b19208478"

    maybe(
        http_archive,
        name = "Needle",
        url = "https://github.com/uber/needle/archive/refs/tags/v%s.tar.gz" % NEEDLE_VERSION,
        strip_prefix = "needle-%s" % NEEDLE_VERSION,
        sha256 = NEEDLE_SHA_256,
        build_file = "@nodes_architecture_framework//bazel:dependencies/Needle/BUILD",
    )

    NIMBLE_VERSION = "13.0.0"
    NIMBLE_SHA_256 = "727b05a2dfd286d16cb516e58c27a3aa4ea2ba1c520fabec2056fefd14f146ca"

    maybe(
        http_archive,
        name = "Nimble",
        url = "https://github.com/Quick/Nimble/archive/refs/tags/v%s.tar.gz" % NIMBLE_VERSION,
        strip_prefix = "Nimble-%s" % NIMBLE_VERSION,
        sha256 = NIMBLE_SHA_256,
        build_file = "@nodes_architecture_framework//bazel:dependencies/Nimble/BUILD",
    )

    PATHKIT_VERSION = "1.0.1"
    PATHKIT_SHA_256 = "fcda78cdf12c1c6430c67273333e060a9195951254230e524df77841a0235dae"

    maybe(
        http_archive,
        name = "PathKit",
        url = "https://github.com/kylef/PathKit/archive/refs/tags/%s.tar.gz" % PATHKIT_VERSION,
        strip_prefix = "PathKit-%s" % PATHKIT_VERSION,
        sha256 = PATHKIT_SHA_256,
        build_file = "@nodes_architecture_framework//bazel:dependencies/PathKit/BUILD",
    )

    SNAPSHOTTESTING_VERSION = "1.15.1"
    SNAPSHOTTESTING_SHA_256 = "9b7b1a075ef4baf17a0181e815e858fde89d58cfef8fef418464e97a0754d509"

    maybe(
        http_archive,
        name = "SnapshotTesting",
        url = "https://github.com/pointfreeco/swift-snapshot-testing/archive/refs/tags/%s.tar.gz" % SNAPSHOTTESTING_VERSION,
        strip_prefix = "swift-snapshot-testing-%s" % SNAPSHOTTESTING_VERSION,
        sha256 = SNAPSHOTTESTING_SHA_256,
        build_file = "@nodes_architecture_framework//bazel:dependencies/SnapshotTesting/BUILD",
    )

    STENCIL_VERSION = "0.15.1"
    STENCIL_SHA_256 = "7e1d7b72cd07af0b31d8db6671540c357005d18f30c077f2dff0f84030995010"

    maybe(
        http_archive,
        name = "Stencil",
        url = "https://github.com/stencilproject/Stencil/archive/refs/tags/%s.tar.gz" % STENCIL_VERSION,
        strip_prefix = "Stencil-%s" % STENCIL_VERSION,
        sha256 = STENCIL_SHA_256,
        build_file = "@nodes_architecture_framework//bazel:dependencies/Stencil/BUILD",
    )

    SWIFTSYNTAX_VERSION = "509.0.2"
    SWIFTSYNTAX_SHA_256 = "1a516cf344e4910329e3ba28e04f53f457bba23e71e7a4a980515ccc29685dbc"

    maybe(
        http_archive,
        name = "SwiftSyntax",
        url = "https://github.com/apple/swift-syntax/archive/refs/tags/%s.tar.gz" % SWIFTSYNTAX_VERSION,
        strip_prefix = "swift-syntax-%s" % SWIFTSYNTAX_VERSION,
        sha256 = SWIFTSYNTAX_SHA_256,
    )

    YAMS_VERSION = "5.0.6"
    YAMS_SHA_256 = "a81c6b93f5d26bae1b619b7f8babbfe7c8abacf95b85916961d488888df886fb"

    maybe(
        http_archive,
        name = "Yams",
        url = "https://github.com/jpsim/Yams/archive/refs/tags/%s.tar.gz" % YAMS_VERSION,
        strip_prefix = "Yams-%s" % YAMS_VERSION,
        sha256 = YAMS_SHA_256,
    )
