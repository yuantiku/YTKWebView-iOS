#
# Be sure to run `pod lib lint YTKWebView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YTKWebView'
  s.version          = '0.1.0'
  s.summary          = 'YTKWebView is used for UIWebview javascript function injection and call javascript code. '

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
YTKWebView use JavascriptCore for ObjectC function js injection, use UIWebView stringByEvaluatingJavaScriptFromString selector for call javascript code. The implementation code all in the YTKWebViewJSManager.
                       DESC

  s.homepage         = 'https://github.com/yuantiku/YTKWebView-iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lihc' => 'lihc@fenbi.com' }
  s.source           = { :git => 'https://github.com/yuantiku/YTKWebView-iOS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'

  s.source_files = 'YTKWebView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'YTKWebView' => ['YTKWebView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.dependency 'YTKJsBridge', '~> 0.1.0'
end
