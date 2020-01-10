Pod::Spec.new do |s|
	s.name                  = 'ElegantUI'
	s.version               = '1.0.0'
	s.summary               = 'UIKit Extensions In Swift'
	
	s.homepage              = 'https://github.com/alflix/ElegantUI'
	s.license               = { :type => 'Apache-2.0', :file => 'LICENSE' }
	
	s.authors               = { 'John' => 'jieyuanz24@gmail.com' }
	s.source                = { :git => 'https://github.com/alflix/ElegantUI.git', :tag => "#{s.version}" }
	s.ios.framework         = 'UIKit'
	
	s.swift_version         = "5.1"
	s.ios.deployment_target = "9.0"
	s.platform              = :ios, '9.0'
	
	s.module_name           = 'ElegantUI'
	s.requires_arc          = true
	s.source_files          = 'Source/**/*.swift'
	s.resources             = 'Resources/**/*'

end
