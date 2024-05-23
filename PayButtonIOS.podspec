Pod::Spec.new do |spec|
  spec.name         = "PayButtonIOS"
  spec.version      = "1.1.0"
  spec.summary      = "Paysky PayButton SDK"
  spec.description  = "The PayButton helps make the integration of card acceptance into your app easy."
  spec.homepage     = "https://github.com/payskyCompany/payButtonIOS"
  spec.license      = "MIT"

  spec.author             = { "Paysky" => "abdullah.tarek@paysky.io" }
  spec.social_media_url   = "https://paysky.io/"

  spec.platform           = :ios, "13.0"
  spec.source             = { :git => "https://github.com/payskyCompany/PayButtonIOS.git", :tag => spec.version.to_s }
  spec.swift_version      = "5.0"

  spec.source_files       = "PayButton/**/*"
  
  spec.exclude_files      = [
    "PayButton/TestApi/Base.lproj/LaunchScreen.storyboard",
    "PayButton/TestApi/Base.lproj/Main.storyboard",
    "PayButton/TestApi/ViewController.swift",
    "PayButton/AppDelegate.swift",
    "PayButton/Info.plist",
    "PayButton/Resources/PayButtonAssets.xcassets/AppIcon.appiconset/**"
  ]

  spec.public_header_files = "PayButton/PayButton-Bridging-Header.h"

  spec.resources = "PayButton/**/*.{png,jpeg,jpg,storyboard,xib,xcassets,lproj,json,plist,strings}"

  spec.framework          = "UIKit"

  spec.requires_arc       = true
  spec.static_framework   = true

  spec.xcconfig = {
    "APPLY_RULES_IN_COPY_FILES" => "YES",
    "STRINGS_FILE_OUTPUT_ENCODING" => "binary",
    "OTHER_LDFLAGS" => "-lz"
  }
  
  spec.pod_target_xcconfig = { "EXCLUDED_ARCHS[sdk=iphonesimulator*]" => "arm64" }
  spec.user_target_xcconfig = { "EXCLUDED_ARCHS[sdk=iphonesimulator*]" => "arm64" }

  spec.dependency "Alamofire", "~> 5.0.5"
  spec.dependency "DLRadioButton", "~> 1.4.12"
  spec.dependency "MOLH", "~> 1.4.3"
  spec.dependency "PayCardsRecognizer", "~> 1.1.7"
  spec.dependency "PopupDialog", "~> 1.1.1"
end
