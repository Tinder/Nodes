<div align="center">

[![Lint](https://github.com/TinderApp/Nodes/actions/workflows/lint.yml/badge.svg?event=push)](https://github.com/TinderApp/Nodes/actions/workflows/lint.yml)
&nbsp;
[![Swift](https://github.com/TinderApp/Nodes/actions/workflows/swift.yml/badge.svg?event=push)](https://github.com/TinderApp/Nodes/actions/workflows/swift.yml)
&nbsp;
[![Xcode](https://github.com/TinderApp/Nodes/actions/workflows/xcode.yml/badge.svg?event=push)](https://github.com/TinderApp/Nodes/actions/workflows/xcode.yml)
&nbsp;
[![Bazel](https://github.com/TinderApp/Nodes/actions/workflows/bazel.yml/badge.svg?event=push)](https://github.com/TinderApp/Nodes/actions/workflows/bazel.yml)
&nbsp;
[![DocC](https://github.com/TinderApp/Nodes/actions/workflows/docc.yml/badge.svg?event=push)](https://github.com/TinderApp/Nodes/actions/workflows/docc.yml)
&nbsp;
[![Genesis](https://github.com/TinderApp/Nodes/actions/workflows/genesis.yml/badge.svg?event=push)](https://github.com/TinderApp/Nodes/actions/workflows/genesis.yml)

[![Pages](https://github.com/TinderApp/Nodes/actions/workflows/pages.yml/badge.svg?event=push)](https://github.com/TinderApp/Nodes/actions/workflows/pages.yml)
&nbsp;
[![Artifactory](https://github.com/TinderApp/Nodes/actions/workflows/artifactory.yml/badge.svg?event=push)](https://github.com/TinderApp/Nodes/actions/workflows/artifactory.yml)

<img src="Nodes.png" />

</div>

# Nodes Architecture Framework

Native Mobile Application Engineering at Scale

[https://github.com/TinderApp/Nodes](https://github.com/TinderApp/Nodes)

At Tinder, we create mobile applications ***to power and inspire real connections by making it easy and fun for every new generation of singles***. And to do that successfully, we assembled a large team of mobile engineers who continually deliver numerous concurrent projects to empower, delight and protect our countless members around the globe.

We think [Swift](https://developer.apple.com/swift) and related technologies including [SwiftUI](https://developer.apple.com/xcode/swiftui) and [Swift Concurrency](https://developer.apple.com/documentation/swift/swift_standard_library/concurrency) are simply awesome. However, creating mobile applications at Tinder's scale requires a scalable application architecture as well. We designed the Nodes Architecture Framework to specifically address how to build a complex app, with a large team, involving many simultaneous initiatives.

Nodes provides a modular and plugin-based approach to assembling an app with countless screens and features. Nodes leverages reactive data streams for state management to allow app state to be distributed, which is essential when many different teams own different parts of the codebase. Nodes is not opinionated about which reactive library to use however, or even which UI framework to use. In fact, Nodes is fully compatible with [SwiftUI](https://developer.apple.com/documentation/swiftui), [UIKit](https://developer.apple.com/documentation/uikit) and [AppKit](https://developer.apple.com/documentation/appkit).

Although the Nodes Architecture Framework leverages some concepts and patterns similar to [Uber's cross-platform mobile architecture framework](https://github.com/uber/RIBs) (RIBs), it was developed from the ground up to provide unique benefits purpose-built for [Tinder](https://github.com/tinder). ***No source code has been copied from RIBs*** into this framework. Other open source projects such as [Needle](https://github.com/uber/needle) and [Mockolo](https://github.com/uber/mockolo) are utilized as dependencies when creating an app with Nodes.

We ❤️ building mobile applications with Nodes and we hope you ~~will~~ do too!

## Design Goals

#### Reliable Extensibility

An app at scale has to remain as close to 100% reliable as possible while it is mutated and extended, in other words, as new features are added and tested. Due to its design, the Nodes architecture allows every feature to achieve very high test coverage and enables all screens of an application to be fully decoupled from one another. Any feature, any screen, any business rule and any underlying service may be dynamically swapped out for an alternate implementation. This extensibility allows new features and bug fixes to be delivered safely to avoid breaking existing functionality.

#### Feature Implementation Consistency

The Nodes architecture is backed by the Nodes framework which includes base classes and companion types to provide a cookie cutter approach to feature development. Every screen of an application is then implemented with the same exact structure. This consistent repeatable pattern is fostered by Nodes' Xcode templates.

#### Memory Management

Native mobile applications need to be good citizens within their host device and operating system. Memory leaks and even normal memory use must be managed carefully. This can be challenging enough in a small app, and inside a large codebase it can quickly become unmanageable without a clear plan. The Nodes architecture provides controls for the lifecycle of each feature screen in the application which allows all memory of each experience to be reclaimed.

## Documentation

Documentation is available online at: [https://TinderApp.github.io/Nodes](https://TinderApp.github.io/Nodes)

To build Nodes' [DocC](https://developer.apple.com/documentation/docc) documentation and open it in Xcode's documentation window:

```
git clone git@github.com:TinderApp/Nodes.git
cd Nodes
make docs
```

## Quick Start

Following these steps will create a new iOS Xcode project set up with Nodes, Needle and Mockolo.

### Requirements

- Xcode version `13.3` or greater

### Install Dependencies

```
brew install mint xcodegen needle mockolo
mint install yonaskolb/genesis
```

### Clone Nodes Repository

This step may be skipped if the Nodes repository was previously cloned.

> Replace `<version>` in the command with the latest Nodes version and replace `<nodesPath>` in the command with the path to where the Nodes repository will reside.

```
git clone -b <version> git@github.com:TinderApp/Nodes.git <nodesPath>
```

### Create Project Directory

**IMPORTANT:** Do not create the new project within the cloned Nodes repository.

> Replace `<projectPath>` in the command with the path to where the new iOS Xcode project will reside.

```
mkdir -p <projectPath> && cd "$_"
```

### Generate Project Files

> Replace `<nodesPath>` in the command with the path to the cloned Nodes repository.

```
mint run genesis generate <nodesPath>/genesis.yml --options "author:$(git config user.name), date:$(date +"%-m/%-d/%y")"
```

When prompted, enter the latest Nodes version, a name for the new iOS Xcode project and an organization identifier (which is the bundle ID prefix such as `com.tinder`).

**OPTIONAL:** The cloned Nodes repository is no longer needed at this point and may be removed if there is no plan to create additional projects.

### Generate Xcode Project

```
xcodegen
```

Execute the `xcodegen` command any time the `project.yml` file is changed or project files are added or removed. See the [xcodegen](https://github.com/yonaskolb/XcodeGen) documentation for more information.

### Use Xcode Templates

Xcode templates for Nodes will automatically be installed to:

`~/Library/Developer/Xcode/Templates/File Templates/Nodes Architecture Framework (Xcode Templates)`

To add additional Nodes to the project, scroll to the Nodes templates in the new file dialog.

<img src="./.assets/Xcode-Templates.png" width="690" />

### Known Issues

Only if on a Mac computer with Apple silicon, create the following symbolic links to provision these two dependencies within a `$PATH` that Xcode utilizes:

```
ln -s /opt/homebrew/bin/needle /usr/local/bin/needle
ln -s /opt/homebrew/bin/mockolo /usr/local/bin/mockolo
```

Only if issues are encountered when executing Mockolo, build from source:

```
brew reinstall --build-from-source mockolo
```
