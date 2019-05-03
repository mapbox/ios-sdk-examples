platform :ios, '9.0'
use_frameworks!

def shared_pods
    # This uses a local build of the Maps SDK if you are installing from within mapbox-gl-native
    # Build the framework first with `make iframework` to use this option.
    if Dir.pwd.include?('mapbox-gl-native')
      pod 'Mapbox-iOS-SDK', :path => '../../../build/ios/pkg/dynamic/Mapbox-iOS-SDK.podspec'
    else
      pod 'Mapbox-iOS-SDK', '4.10.0'
    end

    pod 'SwiftLint', '~> 0.29'
end

target 'Examples' do
  shared_pods
end

target 'DocsCode' do
  pod 'MapboxNavigation', '0.32.0'
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
