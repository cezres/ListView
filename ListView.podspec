Pod::Spec.new do |spec|

  spec.name         = "ListView"
  spec.version      = "1.0.0"
  spec.summary      = "ListView."
  spec.description  = <<-DESC
  ListView
                   DESC
  spec.homepage     = "https://github.com/Bytom/Bycoin.iOS"
  spec.license      = "MIT"
  spec.author       = { "cezres" => "cezr@sina.com" }


  spec.swift_version            = '5'
  spec.module_name              = 'ListView'
  spec.platform                 = :ios, "10.0"
  spec.ios.deployment_target    = "10.0"


  spec.source               = { :git => "https://github.com/cezres/ListView.git", :tag => "#{spec.version}" }
  spec.source_files         = "ListView", "ListView/**/*.{h,swift}"
  spec.public_header_files  = "ListView/**/*.h"


  spec.dependency "DifferenceKit"
  spec.dependency "PromiseKit"
  
end
