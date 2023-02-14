# Contributing to Nodes

- [Project Setup](#project-setup)
- [Creating Releases](#creating-releases)

## Project Setup

### Requirements

- Xcode version `13.3` or greater

### Install dependencies

```
$ brew install libgit2
```

### Clone repository

```
$ git clone git@github.com:TinderApp/Nodes.git && cd Nodes
```

### Open project in Xcode

```
$ xed Package.swift
```

Confirm all package dependencies are resolved successfully before continuing.

### Building

Confirm the `Nodes-Package` scheme is selected and then select `Build` from the `Product` menu (Command-B).

### Testing

Confirm the `Nodes-Package` scheme is selected and then select `Test` from the `Product` menu (Command-U).

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
