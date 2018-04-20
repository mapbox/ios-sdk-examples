platform :ios, '8.0'
use_frameworks!

def shared_pods
    pod 'Mapbox-iOS-SDK', podspec: 'https://raw.githubusercontent.com/mapbox/mapbox-gl-native/ios-v4.0.0/platform/ios/Mapbox-iOS-SDK.podspec'
end

target 'Examples' do
    shared_pods
    #pod 'Mapbox-iOS-SDK-symbols', :path => '/Users/jordankiley/Desktop/repos/mapbox-gl-native/build/ios/pkg/dynamic/Mapbox-iOS-SDK-symbols.podspec'
end

target 'DocsCode' do
  platform :ios, '9.0'
  #pod 'MapboxNavigation', '~> 0.11'
  shared_pods
end

target 'ExamplesTests' do
  # Pods for testing
end

target 'ExamplesUITests' do
  # Pods for testing
end
