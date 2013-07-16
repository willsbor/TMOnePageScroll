Pod::Spec.new do |s|
  s.name         = "TMOnePageScroll_kang"
  s.version      = "0.0.2"
  s.summary      = "One-page style view."
  s.homepage     = "https://github.com/willsbor/TMOnePageScroll"
  s.license      = 'MIT'
  s.author       = { "willsbor Kang" => "willsbor@gmail.com" }
  s.source       = { :git => "https://github.com/willsbor/TMOnePageScroll.git", :tag => "#{s.version}" }
  s.platform     = :ios, '5.1'
  s.source_files = 'TMOnePageScroll/Library/*.{h,m}'
  s.framework  = 'QuartzCore'
  s.requires_arc = true
end
