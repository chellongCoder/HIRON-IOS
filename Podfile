# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'Heron' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for 
  pod 'SnapKit',                  '5.0.1'
  pod 'SWRevealViewController',   '2.3.0'
  
  pod 'Alamofire',                '5.2.0'
  pod 'ObjectMapper',             '4.2.0'
  pod 'SDWebImage',               '5.7.3'
  pod 'OneSignalXCFramework',     '>= 3.0.0', '< 4.0'
  
  pod 'NVActivityIndicatorView',  '5.1.1'
  pod 'BadgeHub',                 '1.0.0'
  pod 'IQKeyboardManager',        '6.5.10'
  pod 'SkeletonView',             '1.11.0'
  pod 'Material',                 '3.1.8'
  pod 'MaterialComponents/Chips', '119.1.3'
  pod 'FSCalendar',               '2.8.4'
  pod 'PhoneNumberKit',           '3.3.4'
  pod 'iCarousel',                '1.8.3'
  pod 'DropDown',                 '2.3.13'
  pod 'RxSwift',                  '6.5.0'
  pod 'RxCocoa',                  '6.5.0'
  pod 'SwiftLint',                '0.47.1'
  
  #Tracking
  pod 'BugfenderSDK',             '1.10.4'
  # pod 'AppsFlyerFramework',       '6.2.6'
  # pod 'Firebase/Analytics'
  # pod 'Mixpanel-swift',           '2.9.3'

  #Payment
  pod 'Stripe',                   '22.7.0'
  
  target 'HeronTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'HeronUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
    # some older pods don't support some architectures, anything over iOS 11 resolves that
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
