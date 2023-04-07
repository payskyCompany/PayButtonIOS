Pod::Spec.new do |s|
  s.name             = 'PayButton'
  s.version          = '0.6.4'
  s.summary          = 'PayButton'
 
  s.description      = "PaySky PayButton SDK"

  s.homepage         = 'https://github.com/payskyCompany/payButtonIOS'
 
  s.license          = { :type => 'MIT', :file => 'README.md' }

  s.author           = { 'payskyCompany' => 'ahmed.agamy@paysky.io' }

  s.platform         = :ios
  
  s.ios.deployment_target = "13.0"

  s.source           = { :git => 'https://github.com/payskyCompany/payButtonIOS.git', :tag => "#{s.version}" }
 
  s.xcconfig = { "APPLY_RULES_IN_COPY_FILES" => "YES", "STRINGS_FILE_OUTPUT_ENCODING" => "binary" ,"OTHER_LDFLAGS" => "-lz" }
 
  s.public_header_files = 'PayButton/PayButton-Bridging-Header.h'
  
  s.framework = "UIKit"

  s.swift_version = '5'
  
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  s.dependency 'Alamofire', '~> 5.0.5'
  s.dependency 'DynamicBlurView', '~> 4.1.0'
  s.dependency 'EVReflection', '~> 5.10.1'
  s.dependency 'MOLH', '~> 1.4.3'
  s.dependency 'PayCardsRecognizer', '~> 1.1.7'
  s.dependency 'PopupDialog', '~> 1.1.1'
  
  s.static_framework = true
  s.requires_arc = true
  
  s.source_files = "PayButton/**/*.{swift,h,m}"
  s.resources = "PayButton/**/*.{png,jpeg,jpg,storyboard,xib,xcassets,lproj,json,plist,strings}"
  s.resource_bundle = { "PayButton" => ["PayButton/Strings/*.lproj/*.strings"] }
  
  s.exclude_files = [
    'PayButton/TestApi/Base.lproj/LaunchScreen.storyboard',
    'PayButton/TestApi/Base.lproj/Main.storyboard',
    'PayButton/TestApi/ViewController.swift',
    'PayButton/AppDelegate.swift',
    'PayButton/Info.plist',
    'PayButton/Assets.xcassets/AppIcon.appiconset/**',
  ]
        
end
