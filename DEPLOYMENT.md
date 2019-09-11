# TestFlight deployment

These instructions are intended for internal Mapbox developers.

## Build and deploy to TestFlight

### Automatically on CI

1. [Navigate to the `ios-sdk-examples` Bitrise project.](https://app.bitrise.io/app/9a144f2169b7c9e3)
2. Manually start a new build on your desired branch (typically `ios-vX.X.X` or `master`) with the `testflight` workflow.
3. Wait for the build to complete and for the TestFlight upload to process.

### Manually

1. Follow the [Getting Started](README.md#getting-started) instructions.
2. `bundle exec fastlane beta`
3. Wait 15-30 minutes for release notes to be added to the processed build.

## Using TestFlight builds

TestFlight builds are available only to internal Mapbox developers. For access, invite yourself to the Mapbox Examples app's internal testers group.

## Notes

- Make sure you've set these two environment variables: `MATCH_REPO` and `MATCH_USER`
- Fastlane Match information can be found in your password manager under "Fastlane Match Repo".
- Only regenerate Fastlane Match certificates and profiles using the "Apple Machine User".
- Do not commit any changes that might happen during deployment — version bumps happen automatically based on TestFlight status and do not depend on local state.
