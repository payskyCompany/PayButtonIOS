# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

target 'PayButton' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PayButton
   pod 'Alamofire', '~> 5.0.0-rc.3'
   pod 'PopupDialog'
   pod 'PayCardsRecognizer'
   pod 'MOLH'
   pod 'DLRadioButton'
   
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
