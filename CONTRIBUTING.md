# Contributing to Nodes

- [Dependencies](#dependencies)
- [Open Package in Xcode](#open-package-in-xcode)
- [Static Analysis](#static-analysis)
- [Testing](#testing)
- [Creating Releases](#creating-releases)

## Dependencies

Follow the [Swift Package Resources installation instructions](https://github.com/TinderApp/Swift-Package-Resources) to install tooling dependencies.

## Open Package in Xcode

```
make open
```

> The file header comment template will also be installed.

## Static Analysis

Package dependencies must be resolved to download the SwiftLint binary.

```
swift package resolve
```

SwiftLint violations will be shown in Xcode. And SwiftLint may also be run from the command line.

```
make lint
```

Enable new rules whenever SwiftLint is upgraded to a new version.

```
make rules
```

## Testing

To re-record all existing snapshot references, delete all using the following command and then run the tests.

```
make delete-snapshots
```

## Creating Releases

Releases are made by tagging a commit which is done via the GitHub website. Each tagged release contains zip files of the Nodes framework and DocC archive which are created manually and uploaded to the GitHub release. Note that GitHub automatically includes the source code as both zip and tar archives as well.

In all of the following steps, `X.X.X` is a placeholder to be substituted with the actual semantic version for the release.

### Step 1 - GitHub Website

- Click on `Draft new release` on GitHub releases page
- Enter a semantic version as the new tag (__WITHOUT__ `v` prefix)
- Set the `main` branch as the target (it should be the default)
- Enter the release title formatted as `Nodes vX.X.X` (__WITH__ `v` prefix)
- Click on `Generate release notes`
- Leave `Set as a pre-release` unchecked
- Leave `Set as the latest release` checked
- Click `Publish release`

### Step 2 - Local Working Copy

- Checkout `main` branch and pull
- Verify that the latest commit is tagged with the tag created in Step 1, then perform the following shell commands:

```
make release version="X.X.X"
```

```
mv .build/xcframework/Nodes.xcframework-X.X.X.zip ~/Desktop
```

```
make docs open="no"
```

```
mv .build/documentation/archive/Nodes.doccarchive ~/Desktop/Nodes-X.X.X.doccarchive
```

### Step 3 - Desktop

- Control-click on the `Nodes-X.X.X.doccarchive` file and choose `Compress "Nodes-X.X.X.doccarchive"`
- Double-click on the `Nodes-X.X.X.doccarchive` to open in Xcode and verify it contains any expected documentation changes

### Step 4 - GitHub Website

- Edit the release created in Step 1
- Upload the `Nodes.xcframework-X.X.X.zip` and `Nodes.doccarchive-X.X.X.zip` files created in Steps 2 and 3
- Click `Update release`

### Step 5 - Cleanup

- Remove files on desktop that are no longer needed:
  - `Nodes.xcframework-X.X.X.zip`
  - `Nodes.doccarchive-X.X.X.zip` and `Nodes.doccarchive-X.X.X`
