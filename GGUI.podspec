Pod::Spec.new do |s|
	s.name = 'GGUI'
	s.version = '1.0'
	s.summary = 'Ganguo UI Kit In Swift'
	s.homepage = 'https://www.ganguotech.com/'
	s.license	 = { :type => "Copyright", :text => "Copyright 2019" }
	s.authors = { 'John' => 'john@ganguo.hk' }
	s.source = { :path => 'Source' }	

	s.swift_version = "5.0"
	s.ios.deployment_target = "10.0"
	s.platform = :ios, '10.0'
	s.requires_arc = true
	s.default_subspec = 'Core'

	s.subspec 'Core' do |cs|	
		cs.dependency 'SnapKit'
		cs.dependency 'SwifterSwift'		
		cs.source_files  = 'Source/Core/**/*.swift'
		cs.resources = 'Resources/**/*'
	end

	s.subspec 'AlamofireImage' do |ss|
	    ss.dependency      'GGUI/Core'
	    ss.dependency      'AlamofireImage'
	    ss.source_files  = 'Source/AlamofireImage/*.swift'
	end

	s.subspec 'SwiftTimer' do |ss|
	    ss.dependency      'GGUI/Core'
	    ss.dependency      'SwiftTimer'
	    ss.source_files  = 'Source/SwiftTimer/*.swift'
	end

	s.subspec 'MBProgressHUD' do |ss|
	    ss.dependency      'GGUI/Core'
	    ss.dependency      'MBProgressHUD'
	    ss.source_files  = 'Source/MBProgressHUD/*.swift'
	end

	s.subspec 'Reusable' do |ss|
	    ss.dependency      'GGUI/Core'
	    ss.dependency      'Reusable'
	    ss.source_files  = 'Source/Reusable/*.swift'
	end
	
	s.subspec 'GGNavigationBar' do |ss|
	    ss.dependency      'GGUI/Core'
	    ss.source_files  = 'Source/GGNavigationBar/*.swift'
	end

    s.subspec 'SegementSlide' do |ss|
	    ss.dependency      'GGUI/GGNavigationBar'
	    ss.source_files  = 'Source/SegementSlide/**/*.swift'
	end

	s.subspec 'PullToRefreshKit' do |ss|
	    ss.dependency      'GGUI/Core'
	    ss.source_files  = 'Source/PullToRefreshKit/Source/*.swift'
	end

	s.subspec 'SwiftLocation' do |ss|
	    ss.dependency      'GGUI/Core'
	    ss.dependency      'SwiftLocation'
	    ss.source_files  = 'Source/SwiftLocation/*.swift'
	end

	s.subspec 'AXPhotoViewer' do |ss|
	    ss.dependency      'GGUI/Core'
	    ss.dependency      'AXPhotoViewer/Core'
	    ss.dependency      'AlamofireImage'
	    ss.source_files  = 'Source/AXPhotoViewer/*.swift'
	end
end
