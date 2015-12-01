
Pod::Spec.new do |s|
  s.name             = "AUMediaNormalizer"
  s.version          = "0.1.1"
  s.summary          = "Create and store thumbnails for movies or images."
  s.homepage         = "https://github.com/appunite/AUMediaNormalizer"
  s.license          = 'MIT'
  s.author           = { "Emil Wojtaszek" => "emil@appunite.com" } 
  s.source           = { :git => "git@git.appunite.com:appunite/AUMediaNormalizer.git", :tag => s.version.to_s }
  
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.public_header_files = 'NetworkLib/**/*.h'
  s.source_files = 'Pod/Classes/**/*'
  s.frameworks = 'MobileCoreServices'
  
  s.dependency 'NYXImagesKit'
  s.dependency 'SDAVAssetExportSession'
  s.dependency 'Mantle'

end
