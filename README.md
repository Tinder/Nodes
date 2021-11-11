# Nodes Architecture Framework

Native Mobile Application Engineering at Scale

## RIBs Comparison

The Nodes Architecture Framework leverages many of the same concepts and patterns used in [Uber's cross-platform mobile architecture framework](https://github.com/uber/RIBs) (RIBs) while incorporating additional benefits purpose built for Tinder. **No source code has been copied from RIBs** to create this framework. Other Uber open source projects such as [Needle](https://github.com/uber/needle) and [Mockolo](https://github.com/uber/mockolo) are utilized as dependencies.

## Nodes Benefits

| | Nodes | RIBs |
| --- | :---: | :---: |
| Plugin System Included | ✅ | ❌ |
| [Needle](https://github.com/uber/needle) Setup Out-of-the-Box | ✅ | ❌ |
| Compatible with Any Reactive Library (Combine, Rx, etc.) | ✅ | ❌ |
| Compatible with Any View Framework (SwiftUI, UIKit, AppKit, etc.) | ✅ | ❌ |

As the lowest level dependency in a mobile app it is crucial that the implementation of this framework is fully owned and understood in order to address new feature requests and urgent bug fixes prompty in an ongoing capacity.
