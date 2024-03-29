#
#  Be sure to run `pod spec lint Layout.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "Layout"
  spec.version      = "0.0.4"
  spec.summary      = "Framework for creating declarative layout"
  spec.description  = "Provides a declarative API to easily calculate view's frames"
  spec.homepage     = "https://github.com/librecht-official/Layout"
  spec.source       = { :git => "https://github.com/librecht-official/Layout.git", :tag => "0.0.4" }

  spec.license      = "MIT"
  spec.author       = { "Vladislav Librecht" => "maclibrecht@gmail.com" }

  spec.platform     = :ios, "10.0"
  spec.requires_arc = true
  spec.swift_version = "5.0"

  spec.source_files  = "Layout/**/*.swift"
  spec.exclude_files = "Example", "LayoutTests"

  spec.test_spec "LayoutTests" do |test_spec|
    test_spec.source_files = "LayoutTests/*.swift"
  end

end
