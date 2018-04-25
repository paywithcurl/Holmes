# coding: utf-8
Pod::Spec.new do |s|
  s.name = "Holmes"
  s.version = "0.1.0"
  s.summary = "`Serialize` and `Deserialize` traits to be used with Sherlock."
  s.author = { "Árpád Goretity" => "h2co3@h2co3.org" }
  s.license = { :type => "MIT" }
  s.swift_version = "3.2"
  s.homepage = "https://paywithcurl.com"
  s.social_media_url = "https://twitter.com/paywithcurl"
  s.source = { :git => "https://github.com/paywithcurl/Holmes.git", :tag => "#{s.version}" }
  s.source_files = "Sources/**/*.swift"
  s.frameworks = "Foundation"
  s.ios.deployment_target  = '10.0'
end
