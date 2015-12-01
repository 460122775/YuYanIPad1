use_frameworks! # Add this if you are targeting iOS 8+ or using Swift
pod 'Mapbox-iOS-SDK'
pod 'CocoaAsyncSocket'
# pod 'FMDB'
# pod 'ArcGIS-Runtime-SDK-iOS'
pod 'SQLite.swift', git: 'https://github.com/stephencelis/SQLite.swift.git'
# pod 'HanekeSwift'
# pod 'YYHRequest'
# pod 'ASIHTTPRequest'
pod 'Alamofire'
pod 'SSZipArchive'

# disable bitcode in every sub-target
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end