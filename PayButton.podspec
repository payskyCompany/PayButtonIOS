Pod::Spec.new do |s|
  s.name             = 'PayButton'
  s.version          = '1.1.0'
  s.summary          = 'PayButton'
 
  s.description      = "PaySky PayButton SDK"

  s.homepage         = 'https://github.com/payskyCompany/payButtonIOS'
 
  s.license          = { :type => 'MIT', :file => 'README.md' }

  s.author           = { 'payskyCompany' => 'ahmed.agamy@paysky.io' }

  s.platform         = :ios
  
  s.ios.deployment_target = "14.0"

  s.source           = { :git => 'https://github.com/payskyCompany/payButtonIOS.git', :tag => "#{s.version}" }
 
  s.xcconfig = { "APPLY_RULES_IN_COPY_FILES" => "YES", "STRINGS_FILE_OUTPUT_ENCODING" => "binary" ,"OTHER_LDFLAGS" => "-lz" }
 
  s.public_header_files = 'PayButton/PayButton-Bridging-Header.h'
  
  s.framework = "UIKit"

  s.swift_version = '5'
  
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  s.dependency 'Alamofire', '~> 5.0.5'
  s.dependency 'DLRadioButton'
  s.dependency 'DynamicBlurView'
  s.dependency 'MOLH'
  s.dependency 'PayCardsRecognizer'
  s.dependency 'PopupDialog'
  
  s.static_framework = true
  s.requires_arc = true
  
  s.source_files = "PayButton/**/*.{swift,h,m}"
  s.resource_bundle = { "PayButton" => ["PayButton/**/*.{png,jpeg,jpg,storyboard,xib,xcassets,lproj,json,plist,strings}"] }
  
  s.exclude_files = [
    'PayButton/TestApi/Base.lproj/LaunchScreen.storyboard',
    'PayButton/TestApi/Base.lproj/Main.storyboard',
    'PayButton/TestApi/ViewController.swift',
    'PayButton/AppDelegate.swift',
    'PayButton/Info.plist',
    'PayButton/Assets.xcassets/AppIcon.appiconset/**',
  ]
        
end
