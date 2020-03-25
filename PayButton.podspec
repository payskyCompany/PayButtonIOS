Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '12.0'
 s.name             = 'PayButton'
 s.description      = "PayButton PayButton PayButton"
 s.summary          = 'PayButton'
s.requires_arc = true

# 2
s.version = "0.4.9"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
  s.author           = { 'payskyCompany' => 'ahmed.agamy@paysky.io' }
# 5 - Replace this URL with your own GitHub page's URL (from the address bar)
s.homepage = "https://github.com/payskyCompany/payButtonIOS"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => 'https://github.com/payskyCompany/payButtonIOS.git', :tag => s.version.to_s }
 s.exclude_files = [
   'PayButton/TestApi/Base.lproj/LaunchScreen.storyboard',
     'PayButton/TestApi/Base.lproj/Main.storyboard',
     'PayButton/TestApi/ViewController.swift',
     'PayButton/AppDelegate.swift',
     'PayButton/Info.plist',
     'PayButton/Assets.xcassets/AppIcon.appiconset/**',
                         ]
 s.xcconfig = { "APPLY_RULES_IN_COPY_FILES" => "YES", "STRINGS_FILE_OUTPUT_ENCODING" => "binary" ,"OTHER_LDFLAGS" => "-lz" }
          # 'SWIFT_OBJC_BRIDGING_HEADER' => 'PayButton/PayButton-Bridging-Header.h'}
           s.public_header_files = 'PayButton/PayButton-Bridging-Header.h'


# 7
s.framework = "UIKit"
  s.dependency 'Alamofire' , '~> 5.0.0-rc.3'

     s.dependency "EVReflection"  , '~> 5.10.1'
     s.dependency "DynamicBlurView"  , '~> 4.0.0'

         s.dependency 'PayCardsRecognizer'   , '~> 1.1.7'

      s.dependency 'PopupDialog' , '~> 1.1.1'  
 

      
# 8
 s.source_files = "PayButton/**/*.{swift,h,m}"

  # 9
  s.resources = "PayButton/**/*.{png,jpeg,jpg,storyboard,xib,xcassets,lproj,json,plist,strings}"


  s.resource_bundle = { "PayButton" => ["PayButton/Strings/*.lproj/*.strings"] }
end
