

Pod::Spec.new do |s|

  s.name          = "VehicleKeyboard-swift"
  s.version       = "0.9.19"
  s.summary       = "停车王ios车牌键盘，支持原生输入框及格子样式输入框"
  s.homepage      = "https://github.com/parkingwang/vehicle-keyboard-ios"
  s.license       = { :type => 'MIT', :file => 'LICENSE' }
  s.author        = { "yzh" => "yzhtracy@163.com" }
  s.platform      = :ios, "8.0"
  s.source        = { :git => "https://github.com/parkingwang/vehicle-keyboard-ios.git", :tag => "#{s.version}" }
  s.source_files  = ["Source/*/*/*.{h,m,swift}","Source/*/*.{h,m,swift}"]
  s.resource      = ["Source/*/*/*.{bundle,xib}","Source/*/*.{bundle,xib}"]
  s.requires_arc  = true
  s.swift_version = "5.0"
end
