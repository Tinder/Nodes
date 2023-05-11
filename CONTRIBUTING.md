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

Releases are made [on the GitHub website](https://github.com/TinderApp/Nodes/releases/new).

In all of the following steps, `X.X.X` is a placeholder to be substituted with the actual semantic version for the release.

- Enter a semantic version as the new tag (__WITHOUT__ `v` prefix)
- Set the `main` branch as the target (it should be the default)
- Enter the release title formatted as `Nodes vX.X.X` (__WITH__ `v` prefix)
- Click on `Generate release notes`
- Leave `Set as a pre-release` unchecked
- Leave `Set as the latest release` checked
- Click `Publish release`
