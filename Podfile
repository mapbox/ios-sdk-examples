platform :ios, '9.0'
use_frameworks!

def shared_pods
    pod 'Mapbox-iOS-SDK', '5.1.0-alpha.2'
    pod 'SwiftLint', '~> 0.29'
end

target 'Examples' do
  shared_pods
end

# Temporary solution until Navigation moves out of this repo.
# https://github.com/mapbox/ios-sdk-examples/issues/222
# target 'DocsCode' do
#   pod 'MapboxNavigation', '0.34.0'
#   # pod 'MapboxCoreNavigation', :podspec => 'https://raw.githubusercontent.com/mapbox/mapbox-navigation-ios/v0.17.0-beta.1/MapboxCoreNavigation.podspec'
#   # pod 'MapboxNavigation', :podspec => 'https://raw.githubusercontent.com/mapbox/mapbox-navigation-ios/v0.17.0-beta.1/MapboxNavigation.podspec'
#   shared_pods
# end

target 'ExamplesTests' do
  # Pods for testing
end

target 'ExamplesUITests' do
  # Pods for testing
end
