Pod::Spec.new do |s|
  s.name             = 'KGNavigationBar'
  s.version          = '0.3.21'
  s.summary          = 'iOS 导航栏一对一管理，界面转场动画，手势 Pop 退出界面'

  s.description      = <<-DESC
    iOS 导航栏一对一管理，界面转场动画，手势 Pop 退出界面
                       DESC

  s.homepage         = 'https://github.com/wangwanjie/KGNavigationBar'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wangwanjie' => 'vanjay.dev@gmail.com' }
  s.source           = { :git => 'https://github.com/wangwanjie/KGNavigationBar.git', :tag => s.version.to_s }
  s.requires_arc     = true

  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }
  s.ios.deployment_target = '9.0'
  s.frameworks       = 'Foundation', 'UIKit'
  s.source_files = 'KGNavigationBar', 'KGNavigationBar/*/*'
end
