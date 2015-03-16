source "https://github.com/CocoaPods/Specs.git"
platform :ios, "7.0"
inhibit_all_warnings!

pod "libextobjc"
pod "BlocksKit"
pod 'BloodMagic/Injectable'
pod "ImgurSession"
pod "SDWebImage"
pod "CHTCollectionViewWaterfallLayout"
pod "QuickDialog", :git => "https://github.com/escoz/QuickDialog.git"

post_install do |installer|
  installer.project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
    end
  end
end