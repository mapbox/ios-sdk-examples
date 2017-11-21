platform :ios, '8.0'
use_frameworks!

def shared_pods
  pod 'Mapbox-iOS-SDK-symbols', :podspec => 'https://raw.githubusercontent.com/mapbox/mapbox-gl-native/ios-v3.7.0/platform/ios/Mapbox-iOS-SDK-symbols.podspec'
end

target 'Examples' do
  shared_pods
end

target 'DocsCode' do
  platform :ios, '9.0'
  pod 'MapboxNavigation', '~> 0.10'
end

target 'ExamplesTests' do
  # Pods for testing
end

target 'ExamplesUITests' do
  # Pods for testing
end
