Pod::Spec.new do |s|
  s.name             = 'PayButton'
  s.version          = '0.2.7'
  s.summary          = 'PayButton'
 
  s.description      = "PayButton PayButton PayButton"


  s.homepage         = 'https://github.com/payskyCompany/payButtonIOS'
 
  s.license = { :type => 'MIT', :file => 'README.md' }


  s.author           = { 'payskyCompany' => 'ahmed.agamy@paysky.io' }
  s.source           = { :git => 'https://github.com/payskyCompany/payButtonIOS.git', :tag => s.version.to_s }
 

       #   s.xcconfig =  {'SWIFT_OBJC_BRIDGING_HEADER' => 'PayButton/PayButton-Bridging-Header.h}

          #s.platform = :osx, '10.7'
        
        s.xcconfig = { "APPLY_RULES_IN_COPY_FILES" => "YES", "STRINGS_FILE_OUTPUT_ENCODING" => "binary" ,"OTHER_LDFLAGS" => "-lz" }
          # 'SWIFT_OBJC_BRIDGING_HEADER' => 'PayButton/PayButton-Bridging-Header.h'}
           s.public_header_files = 'PayButton/PayButton-Bridging-Header.h'

          s.exclude_files = [
   'PayButton/TestApi/Base.lproj/LaunchScreen.storyboard',
     'PayButton/TestApi/Base.lproj/Main.storyboard',
     'PayButton/TestApi/ViewController.swift',
     'PayButton/AppDelegate.swift',
     'PayButton/Info.plist',
     'PayButton/Assets.xcassets/AppIcon.appiconset/**',
                         ]
           s.platform = :osx, '10.7'
           s.platform = :ios, '8.0'

           s.ios.deployment_target = '11.0'
    	s.framework = "UIKit"

    s.dependency 'Alamofire' , '~> 4.8.1'

     s.dependency 'IQKeyboardManagerSwift'  , '~> 6.2.0'
     s.dependency "EVReflection"  , '~> 5.9.0'
      s.dependency 'EVReflection/Alamofire'  , '~> 5.9.0'

         s.dependency 'PayCardsRecognizer'   , '~> 1.1.4'



    # s.dependency  'Localize-Swift'
      s.dependency 'PopupDialog' , '~> 0.9.2'  
      s.dependency 'QRCode' , '~> 2.0'  


      

       s.dependency 'InputMask' , '~> 4.0.2'
    s.dependency "CreditCardValidator"  , '~> 0.4'
     s.static_framework = true
s.requires_arc = true
      # 8
  s.source_files = "PayButton/**/*.{swift,h,m}"

  # 9
  s.resources = "PayButton/**/*.{png,jpeg,jpg,storyboard,xib,xcassets,lproj,json,plist,strings}"


  s.resource_bundle = { "PayButton" => ["PayButton/Strings/*.lproj/*.strings"] }
end