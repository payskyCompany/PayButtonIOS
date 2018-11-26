Pod::Spec.new do |s|
  s.name             = 'PayButton'
  s.version          = '0.1.0'
  s.summary          = 'PayButton'
 
  s.description      = "PayButton PayButton PayButton"


  s.homepage         = 'https://github.com/payskyCompany/payButtonIOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'payskyCompany' => 'ahmed.agamy@paysky.io' }
  s.source           = { :git => 'https://github.com/payskyCompany/payButtonIOS.git', :tag => s.version.to_s }
 

       #   s.xcconfig =  {'SWIFT_OBJC_BRIDGING_HEADER' => 'PayButton/PayButton-Bridging-Header.h}

          #s.platform = :osx, '10.7'
        
        s.xcconfig = { "APPLY_RULES_IN_COPY_FILES" => "YES", "STRINGS_FILE_OUTPUT_ENCODING" => "binary" ,"OTHER_LDFLAGS" => "-lz" }

          s.exclude_files = [
   'PayButton/TestApi/Base.lproj/LaunchScreen.storyboard',
     'PayButton/TestApi/Base.lproj/Main.storyboard',
     'PayButton/TestApi/ViewController.swift'
    
                         ]
          #s.platform = :osx, '10.7'
          #s.platform = :ios, '8.0'

          s.ios.deployment_target = '11.0'
    	s.framework = "UIKit"

    s.dependency 'Alamofire' , '~> 4.7.3'

     s.dependency 'IQKeyboardManagerSwift'  , '~> 6.1.0'
     s.dependency "EVReflection"  , '~> 5.6.2'
     s.dependency 'Toast-Swift' , '~> 3.0.1'
      s.dependency 'EVReflection/Alamofire'  , '~> 5.6.2'

         s.dependency 'PayCardsRecognizer'   , '~> 1.1.4'



    # s.dependency  'Localize-Swift'
      s.dependency 'PopupDialog' , '~> 0.7.1'  
      s.dependency 'QRCode' , '~> 2.0'  


      

       s.dependency 'InputMask' , '~> 3.4.1'
    s.dependency "CreditCardValidator"  , '~> 0.4'
     s.static_framework = true
s.requires_arc = true
      # 8
  s.source_files = "PayButton/**/*.{swift,h,m}"

  # 9
  s.resources = "PayButton/**/*.{png,jpeg,jpg,storyboard,xib,xcassets,lproj,json,plist,strings}"


  s.resource_bundle = { "PayButton" => ["PayButton/Strings/*.lproj/*.strings"] }
end