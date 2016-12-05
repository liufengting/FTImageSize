
Pod::Spec.new do |s|

  s.name         = "FTImageSize"
  s.version      = "0.0.2"
  s.summary      = "Get image size from image url synchronously"
  s.description  = <<-DESC
    	FTImageSize. Get image size from image url synchronously.
                   DESC
  s.homepage     = "https://github.com/liufengting/FTImageSize"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author		 = { "liufengting" => "wo157121900@me.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/liufengting/FTImageSize.git", :tag => "#{s.version}" }
  s.source_files = ["FTImageSize/*.swift"]
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }

end
