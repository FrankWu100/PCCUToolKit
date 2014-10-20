Pod::Spec.new do |s|
  s.name         = "PCCUToolKit"
  s.version      = "0.1.2"
  s.summary      = "The Tool Kit for PCCU"
  s.homepage     = "https://github.com/frankwu100/PCCUToolKit"
  s.license      = { :type => 'MIT License', :file => 'LICENSE' }
  s.author       = { "frankwu100" => "frankwu100@gmail.com" }
  s.source       = { :git => "https://github.com/frankwu100/PCCUToolKit.git", :tag => s.version.to_s }
  s.platform     = :ios, '6.0'
  s.source_files = 'PCCUToolKit/*.{h,m}'
  s.resource     = 'PCCUToolKit/*.{strings,png,xcassets}'
  s.ios.dependency  'SVWebViewController', '~> 1.0'

  s.subspec 'FWToolKit' do |ss|
    ss.source_files = 'PCCUToolKit/FWToolKit/*'  
    ss.requires_arc = false
    ss.compiler_flags = '-fno-objc-arc'
  end
end
