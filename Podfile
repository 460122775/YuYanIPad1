use_frameworks! # Add this if you are targeting iOS 8+ or using Swift
platform :ios, '8.0'
target "YuYanIPad1" do
    
# pod 'ArcGIS-Runtime-SDK-iOS'
# pod 'HanekeSwift'
# pod 'YYHRequest'
# pod 'ASIHTTPRequest'

#pod 'Mapbox-iOS-SDK@sputnik', '~> 1.6.3:-sputnik'
#, :commit => '5997259f51d1be81a5ae86a2138266360f0e6ad9'
#platform :ios, '8.0'
#pod 'Mapbox-iOS-SDK'
#use_frameworks!

pod 'CocoaAsyncSocket', '~> 7.4.3'
pod 'SQLite.swift', '~> 0.10.1'
pod 'Alamofire'
pod 'SSZipArchive'

# ShareSDK -start
pod 'ShareSDK3'
pod 'MOBFoundation'
pod 'ShareSDK3/ShareSDKUI'
pod 'ShareSDK3/ShareSDKPlatforms/QQ'
pod 'ShareSDK3/ShareSDKPlatforms/SinaWeibo'
pod 'ShareSDK3/ShareSDKPlatforms/WeChat'
pod 'ShareSDK3/ShareSDKPlatforms/RenRen'
# ShareSDK -end
end

# disable bitcode in every sub-target
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end