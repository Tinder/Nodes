Pod::Spec.new do |s|
  s.name     = 'Nodes'
  s.version  = '0.0.1'
  s.summary  = 'Tinder Nodes Architecture Framework - native mobile application engineering at scale'
  s.homepage = 'https://github.com/TinderApp/Nodes'
  s.license  = ''
  s.author   = { 'Tinder' => 'info@gotinder.com' }
  s.source   = { :git => 'https://github.com/TinderApp/Nodes.git', :tag => s.version }

  s.macos.deployment_target   = '10.13'
  s.ios.deployment_target     = '11.0'
  s.tvos.deployment_target    = '11.0'
  s.watchos.deployment_target = '5.0'

  s.swift_version = '5.2', '5.3'
  s.source_files  = 'Sources/Nodes/**/*'
end
