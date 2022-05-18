# Nodes Architecture Framework

Native Mobile Application Engineering at Scale

[https://github.com/TinderApp/Nodes](https://github.com/TinderApp/Nodes)

At Tinder we create mobile applications ***to keep the magic of human connection alive***. And to do that successfully, we built a large team of mobile engineers who continually deliver numerous concurrent projects to empower, delight and protect our countless members around the globe.

We think [Swift](https://developer.apple.com/swift) and related technologies including [SwiftUI](https://developer.apple.com/documentation/swiftui) and [Swift Concurrency](https://developer.apple.com/documentation/swift/swift_standard_library/concurrency) are simply awesome. However, building a mobile application at Tinder's scale requires a scalable application architecture as well. We created the Nodes Architecture Framework to specifically address how to build a complex app, with a large team, involving many simultaneous initiatives.

Nodes provides a modular and plugin-based approach to assembling an app with countless screens and features. Nodes leverages reactive data streams for state management to allow app state to be distributed, which is essential when many different teams own different parts of the codebase. Nodes is not opinionated about which reactive library to use however, or even which UI framework to use. In fact, Nodes is fully compatible with [SwiftUI](https://developer.apple.com/xcode/swiftui), [UIKit](https://developer.apple.com/documentation/uikit) and [AppKit](https://developer.apple.com/documentation/appkit).

We also want you to know that the Nodes Architecture Framework leverages some concepts and patterns similar to [Uber's cross-platform mobile architecture framework](https://github.com/uber/RIBs) (RIBs) but was built from the ground up to include unique benefits purpose built for [Tinder](https://github.com/tinder). ***No source code has been copied from RIBs*** to create this framework. Other open source projects such as [Needle](https://github.com/uber/needle) and [Mockolo](https://github.com/uber/mockolo) are utilized as dependencies when creating an app with Nodes.

We ❤️ building mobile applications with Nodes and we hope you ~~will~~ do to.

## Quick Start

Following these steps will create a new iOS Xcode project set up with Nodes, Needle and Mockolo.

### Install dependencies

```
$ brew install mint mockolo needle xcodegen
$ mint install yonaskolb/genesis
```

### Clone Nodes repository

This step may be skipped if the Nodes repository was previously cloned.

> Replace `<nodesPath>` in the command with the path to where the Nodes repository will reside.

```
$ git clone git@github.com:TinderApp/Nodes.git <nodesPath>
```

### Create project directory

**IMPORTANT:** Do not create the new project within the cloned Nodes repository.

> Replace `<projectPath>` in the command with the path to where the new iOS Xcode project will reside.

```
$ mkdir -p <projectPath> && cd "$_"
```

### Generate project files

> Replace `<nodesPath>` in the command with the path to the cloned Nodes repository.

```
$ mint run genesis generate <nodesPath>/genesis.yml --options "author:$(git config user.name), date:$(date +"%-m/%-d/%y")"
```

When prompted, enter a name for the new iOS Xcode project and an organization identifier (bundle ID prefix).

**OPTIONAL:** The cloned Nodes repository is no longer needed at this point and may be removed if there is no plan to create additional projects.

### Generate iOS Xcode project

```
$ xcodegen
```

Execute the `xcodegen` command any time the `project.yml` file is changed or project files are added or removed. See the [xcodegen](https://github.com/yonaskolb/XcodeGen) documentation for more information.

### Use Xcode templates

Xcode templates for Nodes will automatically be installed to:

`~/Library/Developer/Xcode/Templates/File Templates/Tinder Nodes Architecture Framework (Xcode Templates)`

To add additional Nodes to the project, scroll to the Nodes templates in the new file dialog. The `` symbol indicates SwiftUI templates.

<p align="center"><img src="./.assets/Xcode-Templates.png" width="798" /></p>
