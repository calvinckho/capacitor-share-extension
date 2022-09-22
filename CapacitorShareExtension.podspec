
  Pod::Spec.new do |s|
    s.name = 'CapacitorShareExtension'
    s.version = '0.0.1'
    s.summary = 'Capacitor share extension for iOS and Android'
    s.license = 'MIT'
    s.homepage = 'https://github.com/calvinckho/capacitor-share-extension'
    s.author = 'Calvin Ho'
    s.source = { :git => 'https://github.com/calvinckho/capacitor-share-extension', :tag => s.version.to_s }
    s.source_files = 'ios/Plugin/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
    s.ios.deployment_target  = '13.0'
    s.swift_version = '5.1'
    s.dependency 'Capacitor'
  end
