Pod::Spec.new do |s|
  s.name         = "MLVCircularProgressView"
  s.version      = "0.9.0"
  s.summary      = "A progress view that mimics the behaviour of the download progress indicator in the iOS7 Apps Store app."
  s.homepage     = "https://github.com/mattiaslevin/MLVCircularProgressView/"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Mattias Levin" => "mattias.levin@gmail.com" }
  s.source       = { :git => "https://github.com/mattiaslevin/MLVCircularProgressView.git", :tag => "v#{s.version}" }
  s.platform     = :ios
  s.ios.deployment_target = "6.0"
  s.source_files = "MLVCircularProgressView/*.{h,m}"
  s.frameworks = "Foundation", "UIKit", "CoreGraphics"
  s.requires_arc = true
end
