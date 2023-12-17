load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def nodes_dependencies():

    ARGUMENTPARSER_VERSION = "1.3.0"
    ARGUMENTPARSER_SHA_256 = "e5010ff37b542807346927ba68b7f06365a53cf49d36a6df13cef50d86018204"

    http_archive(
        name = "ArgumentParser",
        url = "https://github.com/apple/swift-argument-parser/archive/refs/tags/%s.tar.gz" % ARGUMENTPARSER_VERSION,
        strip_prefix = "swift-argument-parser-%s" % ARGUMENTPARSER_VERSION,
        sha256 = ARGUMENTPARSER_SHA_256,
        build_file = "@Nodes//:external/ArgumentParser.BUILD",
    )

    CODEXTENDED_VERSION = "0.3.0"
    CODEXTENDED_SHA_256 = "2e1195354ede4ca9c4751d910ac0ec84b60ebae4dae22aee3a663b91ea7c81a7"

    http_archive(
        name = "Codextended",
        url = "https://github.com/JohnSundell/Codextended/archive/refs/tags/%s.tar.gz" % CODEXTENDED_VERSION,
        strip_prefix = "Codextended-%s" % CODEXTENDED_VERSION,
        sha256 = CODEXTENDED_SHA_256,
        build_file = "@Nodes//:external/Codextended.BUILD",
    )

    NEEDLE_VERSION = "0.24.0"
    NEEDLE_SHA_256 = "61b7259a369d04d24c0c532ecf3295fdff92e79e4d0f96abaed1552b19208478"

    http_archive(
        name = "Needle",
        url = "https://github.com/uber/needle/archive/refs/tags/v%s.tar.gz" % NEEDLE_VERSION,
        strip_prefix = "needle-%s" % NEEDLE_VERSION,
        sha256 = NEEDLE_SHA_256,
        build_file = "@Nodes//:external/Needle.BUILD",
    )

    PATHKIT_VERSION = "1.0.1"
    PATHKIT_SHA_256 = "fcda78cdf12c1c6430c67273333e060a9195951254230e524df77841a0235dae"

    http_archive(
        name = "PathKit",
        url = "https://github.com/kylef/PathKit/archive/refs/tags/%s.tar.gz" % PATHKIT_VERSION,
        strip_prefix = "PathKit-%s" % PATHKIT_VERSION,
        sha256 = PATHKIT_SHA_256,
        build_file = "@Nodes//:external/PathKit.BUILD",
    )

    STENCIL_VERSION = "0.15.1"
    STENCIL_SHA_256 = "7e1d7b72cd07af0b31d8db6671540c357005d18f30c077f2dff0f84030995010"

    http_archive(
        name = "Stencil",
        url = "https://github.com/stencilproject/Stencil/archive/refs/tags/%s.tar.gz" % STENCIL_VERSION,
        strip_prefix = "Stencil-%s" % STENCIL_VERSION,
        sha256 = STENCIL_SHA_256,
        build_file = "@Nodes//:external/Stencil.BUILD",
    )

    YAMS_VERSION = "5.0.6"
    YAMS_SHA_256 = "a81c6b93f5d26bae1b619b7f8babbfe7c8abacf95b85916961d488888df886fb"

    http_archive(
        name = "Yams",
        url = "https://github.com/jpsim/Yams/archive/refs/tags/%s.tar.gz" % YAMS_VERSION,
        strip_prefix = "Yams-%s" % YAMS_VERSION,
        sha256 = YAMS_SHA_256,
    )
