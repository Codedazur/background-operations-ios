#
# Be sure to run `pod lib lint CDABackgroundOperations.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "CDABackgroundOperations"
  s.version          = "0.1.4"
  s.summary          = "A wrapper library to work with NSOperationQueues and NSOperations"
  s.description      = <<-DESC
                       Makes it easy to use background operations, by wrapping to work with NSOperationQueues and NSOperations
                       DESC
  s.homepage         = "https://github.com/Codedazur/background-operations-ios"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "tamarabernad" => "tamara@codedazur.es" }
  s.source           = { :git => "https://github.com/Codedazur/background-operations-ios.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'CDABackgroundOperations' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'CDAUtils'
end
