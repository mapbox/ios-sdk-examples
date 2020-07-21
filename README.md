# Mapbox iOS SDK Examples

[![bitrise](https://app.bitrise.io/app/9a144f2169b7c9e3/status.svg?token=yzLGB24ubR_INs6HqUl14g&branch=main)](https://app.bitrise.io/app/9a144f2169b7c9e3#)[![codecov](https://codecov.io/gh/mapbox/ios-sdk-examples/branch/main/graph/badge.svg)](https://codecov.io/gh/mapbox/ios-sdk-examples)

A live Xcode project/app that provides [public examples](https://www.mapbox.com/ios-sdk/examples/) for the Mapbox Maps SDK for iOS.

## How to receive help
We are not able to answer support questions in this repository — it is intended to show examples of what is possible with the Mapbox Maps SDK for iOS.  If you have questions about how to use the Mapbox Maps SDK for iOS, please see our excellent [documentation](https://docs.mapbox.com/help/) or ask the community at [Stack Overflow](http://stackoverflow.com/questions/tagged/mapbox+ios).

### Other helpful links
- [Mapbox Maps SDK for iOS API documentation](https://docs.mapbox.com/ios/api/maps/)
- [First steps with the Mapbox Maps SDK for iOS](https://docs.mapbox.com/help/tutorials/first-steps-ios-sdk/)

## Getting started
1. Run `bundle install` to install build/packaging dependencies.
1. Run `bundle exec pod install` to download and integrate dependencies using [CocoaPods](https://cocoapods.org).
1. Create the `mapbox_access_token` file in the base directory and insert your Mapbox access token.
1. Open `Examples.xcworkspace`.

## Adding a new example
See the instructions in [`Examples.h`](Examples/Examples.h) for how to add new examples.
