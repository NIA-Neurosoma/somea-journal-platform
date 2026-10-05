#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint somea_journal_platform.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'somea_journal_platform'
  s.version          = '0.0.1'
  s.summary          = 'Owned journal directory and backup protection verification.'
  s.description      = <<-DESC
Owned journal directory and backup protection verification.
                       DESC
  s.homepage         = 'https://someamethod.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = 'SOMEA'
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'somea_journal_platform_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end

