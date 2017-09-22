inhibit_all_warnings!
use_frameworks!

abstract_target 'Framework' do
  platform :ios, '9.0'

  target 'BeaverTests' do
    pod 'Quick'
    pod 'Nimble'
  end

  target 'BeaverPromiseKit' do
    pod 'PromiseKit', '~> 4.4'
  end
end

post_install do |installer|
  puts("Set Swift version to 4.0")
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.0'
    end
  end
end