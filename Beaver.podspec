Pod::Spec.new do |s|
  s.name         = "Beaver"
  s.version      = "0.1.0"
  s.summary      = "A delightful framework to build your iOS application"
  s.homepage     = "https://github.com/trupin/Beaver"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "Theophane Rupin" => "theophane.rupin@gmail.com" }
  s.source       = { :git => "https://github.com/trupin/Beaver.git", :tag => "#{s.version}" }

  s.ios.deployment_target = "8.0"
  s.default_subspec = "Core"

  s.subspec "Core" do |ss|
    ss.source_files = "Beaver/**/*.swift"
  end

  s.subspec "PromiseKit" do |ss|
    ss.source_files = "Extension/PromiseKit/**/*.swift"
    ss.dependency "PromiseKit", "~> 4.1"
    ss.dependency "Beaver/Core"
  end

  s.subspec "TestKit" do |ss|
    ss.source_files = "BeaverTestKit/**/*.swift"
    ss.dependency "Beaver/Core"
  end
end
