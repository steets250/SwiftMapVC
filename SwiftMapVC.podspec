Pod::Spec.new do |s|
  s.name             = 'SwiftMapVC'
  s.version          = ‘1.0.0’
  s.summary          = ‘Present a map view as a popover controller.’

  s.description      = <<-DESC
Makes showing locations each to accomplish. Given the coordinates for the location and a name, the map popover shows the location relative to the user.
                       DESC

  s.homepage         = 'https://github.com/steets250/MiniTabBar'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { ‘Steven Steiner’ => ‘steets250.com' }
  s.source           = { :git => 'https://github.com/steet250/SwiftMapVC.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/steets250’

  s.ios.deployment_target = ‘9.0’

  s.source_files = 'SwiftMapVC/Classes/**/*'
end
