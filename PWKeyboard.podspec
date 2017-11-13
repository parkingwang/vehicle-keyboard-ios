#
#  Be sure to run `pod spec lint PWKeyboard.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name                = "PWKeyboard"
  s.version             = "1.0.0"
  s.summary             = "Plate Keyboard in china"
  s.homepage            = "https://github.com/parkingwang/vehicle-keyboard-ios"
  s.license             = { :type => 'MIT', :file => 'LICENSE' }
  s.author              = { "f2yu" => "fengziyu@parkingwang.com" }
  s.platform            = :ios, "8.0"
  s.source              = { :git => "https://github.com/parkingwang/vehicle-keyboard-ios", :tag => "1.0.0" }
  s.source_files        = "PWKeyboardDemo/PWKeyboard/**/*.{h,m}"
  s.resources           = ['PWKeyboardDemo/PWKeyboard/js/*','PWKeyboardDemo/PWKeyboard/PWBundle.bundle']
  s.requires_arc	      = true
  s.frameworks   	      = "JavaScriptCore"
  s.dependency "JSONModel"
end
