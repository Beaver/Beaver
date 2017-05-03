inhibit_all_warnings!
use_frameworks!

abstract_target 'Framework' do
  platform :ios, '8.0'

  target 'BeaverTests' do
    pod 'Quick'
    pod 'Nimble'
  end

  target 'BeaverPromiseKit' do
    pod 'PromiseKit', '~> 4.1'
  end
end

post_install do |installer|
  puts("Set Swift version to 3.0")
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end