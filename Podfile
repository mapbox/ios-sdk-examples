platform :ios, '8.0'
use_frameworks!

target 'Examples' do
  pod 'Mapbox-iOS-SDK', podspec: 'https://raw.githubusercontent.com/mapbox/mapbox-gl-native/ios-v4.0.0-beta.3/platform/ios/Mapbox-iOS-SDK.podspec'
 # pod 'Mapbox-iOS-SDK-symbols', :path => '/Users/jordankiley/Desktop/repos/mapbox-gl-native/build/ios/pkg/dynamic/Mapbox-iOS-SDK-symbols.podspec'

end

target 'DocsCode' do
  platform :ios, '9.0'
  # Navigation examples will need to move to
  # https://github.com/mapbox/navigation-ios-examples
  # in order to avoid version conflicts with the
  # Maps SDK in the examples target
  # pod 'MapboxNavigation', '~> 0.11'
  pod 'Mapbox-iOS-SDK', podspec: 'https://raw.githubusercontent.com/mapbox/mapbox-gl-native/ios-v4.0.0-beta.3/platform/ios/Mapbox-iOS-SDK.podspec'
end

target 'ExamplesTests' do
  # Pods for testing
end

target 'ExamplesUITests' do
  # Pods for testing
end
