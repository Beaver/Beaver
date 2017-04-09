Pod::Spec.new do |s|
  s.name         = "Beaver"
  s.version      = "0.0.1"
  s.summary      = "A delightful framework to build your iOS application"
  s.homepage     = "https://github.com/trupin/Beaver"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "Theophane Rupin" => "theophane.rupin@gmail.com" }
  s.source       = { :git => "https://github.com/trupin/Beaver.git", :tag => "#{s.version}" }

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.tvos.deployment_target = "9.0"
  s.watchos.deployment_target = "2.0"

  s.source_files = "Beaver/*.swift"

  s.subspec "PromiseKit" do |ss|
    ss.source_files = "Extensions/PromiseKit/*"
    ss.dependency "PromiseKit", "~> 4.1" 
  end
end
