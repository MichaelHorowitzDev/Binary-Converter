# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Binary Converter' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TextToBinaryFree
pod 'IQKeyboardManagerSwift'
pod 'BigInt'
pod 'Siren'
pod 'PopupDialog'
pod 'Armchair'
pod 'SCLAlertView'
pod 'TableViewDragger'
pod 'paper-onboarding'
post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
  end
 end
end
  target 'Binary ConverterTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Binary ConverterUITests' do
    # Pods for testing
  end

end
