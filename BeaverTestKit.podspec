Pod::Spec.new do |s|
  s.name         = "BeaverTestKit"
  s.version      = "0.1.0"
  s.summary      = "A delightful framework to test your Beaver application"
  s.homepage     = "https://github.com/trupin/Beaver"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "Theophane Rupin" => "theophane.rupin@gmail.com" }
  s.source       = { :git => "https://github.com/trupin/Beaver.git", :tag => "#{s.version}" }

  s.ios.deployment_target = "8.0"

  s.source_files = "BeaverTestKit/**/*.swift"

  s.framework = "XCTest"

  s.dependency = "Beaver", "~> 0.1"
end