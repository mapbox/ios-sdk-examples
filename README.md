# iOS SDK Examples

A live Xcode project/app that runs the Mapbox iOS SDK's public examples.

Eventually this will be used to dynamically generate the example code found on the [SDK's webpage](https://www.mapbox.com/ios-sdk/examples/). Until that happens, the examples live a static life [here](https://github.com/mapbox/ios-sdk/tree/mb-pages/_posts/examples) in the `ios-sdk` repository.

## Goals
- Testability
- Faster documentation updates
- Improve reliability

## Use
1. Run `install.sh` to download `Mapbox.framework`.
1. `cp Examples/APIKeys.EXAMPLE.plist Examples/APIKeys.plist`
1. Add your Mapbox access token to APIKeys.plist.
1. Open `Examples.xcodeproj`.
1. Follow the instructions in `Example.h` to add new examples.
1. ⚗🔬
