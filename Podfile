platform :ios, '8.0'
use_frameworks!

def shared_pods
<<<<<<< HEAD
  #pod 'Mapbox-iOS-SDK', '~> 3.6.3'
  pod 'Mapbox-iOS-SDK-symbols', :podspec => 'https://raw.githubusercontent.com/mapbox/mapbox-gl-native/ios-v3.7.0-beta.2/platform/ios/Mapbox-iOS-SDK-symbols.podspec'
=======
  pod 'Mapbox-iOS-SDK-symbols', :podspec => 'https://raw.githubusercontent.com/mapbox/mapbox-gl-native/ios-v3.7.0-beta.1/platform/ios/Mapbox-iOS-SDK-symbols.podspec'
>>>>>>> bumped podfile
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

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'DocsCode'
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.0'
            end
        end
    end
end
