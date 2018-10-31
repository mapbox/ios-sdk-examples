platform :ios, '9.0'
use_frameworks!

def shared_pods
    pod 'Mapbox-iOS-SDK', '~> 4.6.0-beta.1'
    # pod 'Mapbox-iOS-SDK', :podspec => 'https://raw.githubusercontent.com/mapbox/mapbox-gl-native/ios-v4.6.0-alpha.1/platform/ios/Mapbox-iOS-SDK.podspec'
    pod 'SwiftLint', '~> 0.27'
end

target 'Examples' do
  shared_pods
end

target 'DocsCode' do
  pod 'MapboxNavigation', '~> 0.23.0'
  # pod 'MapboxCoreNavigation', :podspec => 'https://raw.githubusercontent.com/mapbox/mapbox-navigation-ios/v0.17.0-beta.1/MapboxCoreNavigation.podspec'
  # pod 'MapboxNavigation', :podspec => 'https://raw.githubusercontent.com/mapbox/mapbox-navigation-ios/v0.17.0-beta.1/MapboxNavigation.podspec'
  shared_pods
end

target 'ExamplesTests' do
  # Pods for testing
end

target 'ExamplesUITests' do
  # Pods for testing
end
