# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Sillo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Giphy', '=2.1.2'

  # Pods for Sillo
  pod 'Firebase/Core'
  pod 'Firebase/Storage'
  pod 'Firebase/Auth'
  pod 'Firebase/Performance'
  pod 'Firebase/Database'
  pod 'Firebase/Analytics'
  pod 'Firebase/Firestore'
  pod 'Firebase/Messaging'
  pod 'Firebase/Crashlytics'
  pod 'FirebaseUI/Storage'
  pod 'GoogleSignIn'
  pod 'BoringSSL-GRPC', '= 0.0.3', :modular_headers => false
  pod 'gRPC-Core', '= 1.21.0', :modular_headers => false
  pod 'MessageInputBar'
  pod 'PullUpController'
  pod 'IQKeyboardManagerSwift'

  target 'SilloTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SilloUITests' do
    # Pods for testing
  end

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      end
    end
end

end