Pod::Spec.new do |s|

  s.name         = "YCJSlider"
  s.version      = "0.0.1"
  s.summary      = "a swift Refresh control"
  s.description  = <<-DESC
       一个swift的下拉刷新，上拉加载库，UITableview，UICollectionView,UIWebView
                   DESC
  #仓库主页
  s.homepage     = "https://github.com/YangChaoJie/YCJSlider"
  s.license      = "MIT"
  s.author       = { "Yang" => "yangchaojiekaifa@sina.com" }
  s.platform     = :ios,'10.0'
  s.source       = { :git => "https://github.com/YangChaoJie/YCJSlider.git", :tag => "#{s.version}" }
  s.source_files = "YCJSlider/YCJSlider/*.swift"
  s.framework    = "UIKit","Foundation"
  s.requires_arc = true
end
