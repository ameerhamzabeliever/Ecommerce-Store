source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '13.0'

use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!

target 'pisiffik_ios' do

  pod 'R.swift', '5.0.0'
  pod 'SkeletonView'
  pod "FlagPhoneNumber"
  pod 'Alamofire'
  pod 'IQKeyboardManagerSwift', '6.3.0'
  pod 'PhoneNumberKit', '~> 3.3'
  pod 'ActiveLabel'
  pod 'OTPFieldView'
  pod 'IQDropDownTextField'
  pod 'QRCodeReader.swift', '~> 10.1.0'
  pod 'FSPagerView'
  pod "GMStepper"
  pod 'SYBadgeButton'
  pod 'ImageViewer.swift', '~> 3.0'
  pod 'netfox'
  pod 'Kingfisher', '~> 7.0'
  pod 'EmptyDataSet-Swift', '~> 5.0.0'
  pod 'GooglePlaces', '7.0.0'
  pod 'YPImagePicker'
  pod 'Lightbox'
  pod 'Localize-Swift', '~> 3.2'
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'ObjectMapper', '~> 3.5'

  target 'pisiffik_iosTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
      config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
      config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
      config.build_settings['SWIFT_VERSION'] = '5.0'
    end
  end
end
