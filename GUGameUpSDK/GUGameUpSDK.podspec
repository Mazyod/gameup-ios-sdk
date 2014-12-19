Pod::Spec.new do |s|
  s.name         = "GUGameUpSDK"
  s.version      = "0.2.0"
  s.summary      = "GameUp iOS SDK for GameUp.io"
  s.description  = <<-DESC
                   The iOS SDK for GameUp.io gaming backend server. 
                   
                   GameUp is a gaming backend as a service. 
                   For more information please checkout http://www.gameup.io.
                   DESC

  s.homepage     = "https://www.gameup.io"
  s.license      = { :type => "Apache License, Version 2.0", :file => "GUGameUpSDK/LICENCE" }
  s.authors      = { "Mo Firouz" => "mo@gameup.io", "Chris Molozian" => "chris@gameup.io", "Andrei Mihu" => "andrei@gameuo.io" }
  s.social_media_url   = "http://twitter.com/gameupio"
  s.platform     = :ios, "5.0"
  s.source       = { :git => "https://github.com/gameup-io/gameup-ios-sdk.git", :tag => "0.2.0"}
  #s.source       = { :path => "."}
  s.source_files  = "GUGameUpSDK/Classes/*.{h,m}"
  s.public_header_files = "GUGameUpSDK/Classes/*.h"
  s.resources  = "GUGameUpSDK/Classes/*.xib"
  s.requires_arc = true  
  s.ios.deployment_target = "5.0"
  s.frameworks    = 'SystemConfiguration', 'MobileCoreServices'

  s.dependency "AFNetworking", "~> 1.3.4"
  s.dependency "Base64nl", "~> 1.2"

  ## todo figure out SSL Pinning
  #define _AFNETWORKING_PIN_SSL_CERTIFICATES_
  
end
