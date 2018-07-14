source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
use_frameworks!

target 'ChainpointPOC' do
    pod 'Alamofire'
    pod 'ObjectMapper'
    pod 'AlamofireObjectMapper'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_SUPPRESS_WARNINGS'] = 'YES'
        end
    end
end
