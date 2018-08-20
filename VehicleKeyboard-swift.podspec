

Pod::Spec.new do |s|

  s.name         = "VehicleKeyboard-swift"
  s.version      = "0.9.9"
  s.summary      = "停车王ios车牌键盘，支持原生输入框及格子样式输入框"
  s.homepage     = "https://github.com/parkingwang/vehicle-keyboard-ios"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "yzh" => "yzhtracy@163.com" }
  s.platform      = :ios, "8.0"
  s.source       = { :git => "https://github.com/parkingwang/vehicle-keyboard-ios.git", :tag => "0.9.9" }
  s.source_files  = "Source/*"
  s.resource  = ["Source/*.{bundle,xib}"]
  s.requires_arc = true
  s.swift_version = "4.0"
end
