Pod::Spec.new do |s|
s.name = "XCollectionViewLayout"
s.version = "1.0"
s.license = { :type => "MIT", :file => "LICENSE" }
s.platform = :ios, "8.0"
s.summary = "XCollectionViewLayout"
s.homepage = "https://github.com/wangxiaocan/XCCollectionViewLayout"
s.authors = { "xiaocan" => "1217272889@qq.com" }
s.source = { :git => "https://github.com/wangxiaocan/XCCollectionViewLayout.git", :tag => "#{s.version}" }
s.requires_arc = true
s.source_files = "XCollectionViewLayout/*.{h,m}"
s.public_header_files = "XCollectionViewLayout/*.h"
s.frameworks = "UIKit"
end
