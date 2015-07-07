#
# Be sure to run `pod lib lint AUMediaNormalizer.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "AUMediaNormalizer"
  s.version          = "0.1.0"
  s.summary          = "Create and store thumbnails for movies or images."
  s.homepage         = "https://github.com/appunite/AUMediaNormalizer"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Emil Wojtaszek" => "emil@appunite.com" } 
  s.source           = { :git => "https://github.com/appunite/AUMediaNormalizer.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.public_header_files = 'NetworkLib/**/*.h'
  s.source_files = 'Pod/Classes/**/*'
  s.frameworks = 'MobileCoreServices'
  
  s.dependency 'NYXImagesKit', '~> 2.3'
  s.dependency 'SDAVAssetExportSession', '~> 0.0.2'
  s.dependency 'Mantle', '~> 2.0.2'

end
