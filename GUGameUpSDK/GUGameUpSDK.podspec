Pod::Spec.new do |s|
  s.name         = "GUGameUpSDK"
  s.version      = "0.5.0"
  s.summary      = "GameUp iOS SDK for GameUp.io"
  s.description  = <<-DESC
                   The iOS SDK for GameUp.io gaming backend server.

                   GameUp is a gaming backend as a service.
                   For more information please checkout http://www.gameup.io.
                   DESC

  s.homepage     = "https://www.gameup.io"
  s.authors      = { "Mo Firouz" => "mo@gameup.io", "Chris Molozian" => "chris@gameup.io", "Andrei Mihu" => "andrei@gameup.io" }
  s.social_media_url   = "http://twitter.com/gameupio"
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/gameup-io/gameup-ios-sdk.git", :tag => "0.5.0"}

  # FOR RELEASE
  #s.license      = { :type => "Apache License, Version 2.0", :file => "GUGameUpSDK/LICENCE" }
  #s.source_files  = "GUGameUpSDK/Classes/*.{h,m}"
  #s.public_header_files = "GUGameUpSDK/Classes/*.h"
  #s.resources  = "GUGameUpSDK/Classes/*.storyboard"

  # FOR DEVELOPMENT
  s.license      = { :type => "Apache License, Version 2.0", :file => "LICENCE" }
  s.source_files  = "Classes/*.{h,m}"
  s.public_header_files = "Classes/*.h"
  s.resources  = "Classes/*.storyboard"

  s.requires_arc = true
  s.ios.deployment_target = "6.0"
  s.frameworks    = 'SystemConfiguration', 'MobileCoreServices'

  s.dependency "AFNetworking", "~> 2.5.0"
  s.dependency "Base64nl", "~> 1.2"

  ## todo figure out SSL Pinning
  #define _AFNETWORKING_PIN_SSL_CERTIFICATES_
end
