use_frameworks! # Add this if you are targeting iOS 8+ or using Swift
platform :ios, '8.0'
target "YuYanIPad1" do

# pod 'FMDB'
# pod 'ArcGIS-Runtime-SDK-iOS'
# pod 'HanekeSwift'
# pod 'YYHRequest'
# pod 'ASIHTTPRequest'
pod 'CocoaAsyncSocket'
# pod 'Mapbox-iOS-SDK', '~> 1.5.0'
pod 'SQLite.swift', git: 'https://github.com/stephencelis/SQLite.swift.git'
pod 'Alamofire'
pod 'SSZipArchive'
pod 'ShareSDK3'

end

# disable bitcode in every sub-target
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end