Pod::Spec.new do |s|
  s.name     = 'Nodes'
  s.version  = '0.0.14'
  s.summary  = 'Nodes Architecture Framework - Native Mobile Application Engineering at Scale'
  s.homepage = 'https://github.com/TinderApp/Nodes'
  s.license  = ''
  s.author   = { 'Tinder' => 'info@gotinder.com' }
  s.source   = { :git => 'https://github.com/TinderApp/Nodes.git', :tag => s.version }

  s.macos.deployment_target   = `make get-deployment-target platform=macos`
  s.ios.deployment_target     = `make get-deployment-target platform=ios`
  s.tvos.deployment_target    = `make get-deployment-target platform=tvos`
  s.watchos.deployment_target = `make get-deployment-target platform=watchos`

  s.swift_version = '5.5', '5.6', '5.7'
  s.source_files  = 'Sources/Nodes/**/*'
end
