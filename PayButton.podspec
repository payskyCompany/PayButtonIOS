Pod::Spec.new do |s|
  s.name             = 'PayButton'
  s.version          = '0.0.4'
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

          s.ios.deployment_target = '9.0'
    	s.framework = "UIKit"

    s.dependency 'Alamofire' 

     s.dependency 'IQKeyboardManagerSwift' 
     s.dependency "EVReflection"
     s.dependency 'Toast-Swift' 
      s.dependency 'EVReflection/Alamofire' 

         s.dependency 'PayCardsRecognizer' 



    # s.dependency  'Localize-Swift'
      s.dependency 'PopupDialog'
      s.dependency 'QRCode'


      
        s.dependency 'swiftScan' 
       s.dependency 'InputMask' 
    s.dependency "CreditCardValidator" 
     s.static_framework = true
s.requires_arc = true
      # 8
  s.source_files = "PayButton/**/*.{swift,h,m}"

  # 9
  s.resources = "PayButton/**/*.{png,jpeg,jpg,storyboard,xib,xcassets,lproj,json,plist,strings}"


  s.resource_bundle = { "PayButton" => ["PayButton/Strings/*.lproj/*.strings"] }
end