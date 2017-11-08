platform :ios, '8.0'
use_frameworks!

def shared_pods
  pod 'Mapbox-iOS-SDK-symbols', :podspec => 'https://raw.githubusercontent.com/mapbox/mapbox-gl-native/ios-v3.7.0-beta.4/platform/ios/Mapbox-iOS-SDK-symbols.podspec'
end

target 'Examples' do
  shared_pods
end

target 'DocsCode' do
  shared_pods
end

target 'ExamplesTests' do
  # Pods for testing
end

target 'ExamplesUITests' do
  # Pods for testing
end
