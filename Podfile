use_frameworks! # Add this if you are targeting iOS 8+ or using Swift
platform :ios, '8.0'
target "YuYanIPad1" do
    
# pod 'ArcGIS-Runtime-SDK-iOS'
# pod 'HanekeSwift'
# pod 'YYHRequest'
# pod 'ASIHTTPRequest'
pod 'CocoaAsyncSocket'
pod 'Mapbox-iOS-SDK', :git => 'https://github.com/mapbox/mapbox-ios-sdk-legacy.git'
#, :commit => '5997259f51d1be81a5ae86a2138266360f0e6ad9'
# pod 'SQLite.swift', git: 'https://github.com/stephencelis/SQLite.swift.git'
# pod 'SQLite.swift', git: 'https://github.com/stephencelis/SQLite.swift.git', branch: 'cocoapods-xcode-7-3'
pod 'SQLite.swift', :git => 'https://github.com/brandenr/SQLite.swift.git', :commit => '33ced0255e99e85b7ad65288dc777f6bb9c53687'
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