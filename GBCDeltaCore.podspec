Pod::Spec.new do |spec|
  spec.name         = "GBCDeltaCore"
  spec.version      = "0.1"
  spec.summary      = "Game Boy Color plug-in for Delta emulator."
  spec.description  = "iOS framework that wraps Gambatte to allow playing GBC games with Delta emulator."
  spec.homepage     = "https://github.com/rileytestut/GBCDeltaCore"
  spec.platform     = :ios, "14.0"
  spec.source       = { :git => "https://github.com/rileytestut/GBCDeltaCore.git" }

  spec.author             = { "Riley Testut" => "riley@rileytestut.com" }
  spec.social_media_url   = "https://twitter.com/rileytestut"
  
  spec.source_files  = "GBCDeltaCore/**/*.{h,m,mm,cpp,swift}", "gambatte/libgambatte/include/*.h", "gambatte/common/*.h", "gambatte/libgambatte/src/*.h"
  spec.public_header_files = "GBCDeltaCore/Types/GBCTypes.h", "GBCDeltaCore/Bridge/GBCEmulatorBridge.h"
  spec.header_mappings_dir = ""
  spec.resource_bundles = {
    "GBCDeltaCore" => ["GBCDeltaCore/**/*.deltamapping", "GBCDeltaCore/**/*.deltaskin"]
  }
  
  spec.dependency 'DeltaCore'
    
  spec.xcconfig = {
    "HEADER_SEARCH_PATHS" => '"${PODS_CONFIGURATION_BUILD_DIR}"',
    "USER_HEADER_SEARCH_PATHS" => '"${PODS_CONFIGURATION_BUILD_DIR}/DeltaCore/Swift Compatibility Header"',
    "OTHER_CFLAGS" => "-DHAVE_CSTDINT"
  }
  
end
