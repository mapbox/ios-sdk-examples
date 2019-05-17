# TestFlight deployment

These instructions are intended for internal Mapbox developers.

## Build and deploy to TestFlight

1. Follow the [Getting Started](README.md#getting-started) instructions.
1. `bundle exec fastlane beta`
1. Wait 15-30 minutes for release notes to be added to the processed build.

## Using TestFlight builds

TestFlight builds are available only to internal Mapbox developers. For access, invite yourself to the Mapbox Examples app's internal testers group.

## Notes

- Make sure you've set these two environment variables: `MATCH_REPO` and `MATCH_USER`
- Fastlane Match information can be found in your password manager under "Fastlane Match Repo".
- Only regenerate Fastlane Match certificates and profiles using the "Apple Machine User".
- Do not commit any changes that might happen during deployment — version bumps happen automatically based on TestFlight status and do not depend on local state.
