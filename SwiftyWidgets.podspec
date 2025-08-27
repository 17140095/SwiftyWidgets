Pod::Spec.new do |s|
  s.name             = 'SwiftyWidgets'
  s.version          = '1.0.0'
  s.summary          = 'Swifty widgets library for swiftUI projects'
  s.description      = <<-DESC
                        There are list of widgets available for this project
                        1. SwiftyButton
                        2. SwiftyInput
                        3. SwiftyAlert
                        4. CountrySelectory
                        5. DefaultSelector
                        6. ImageSelector
                        7. PhoneSelector
                        8. SegmentedSelector
                        
                        Next you see the updateds of versions
                       DESC
  s.homepage         = 'https://github.com/17140095/SwiftyWidgets'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ali Raza' => '17140095@gift.edu.pk' }
  s.source           = { :git => 'https://github.com/17140095/SwiftyWidgets.git', :tag => s.version.to_s }

  # Swift version and platform
  s.swift_version    = '5.9'
  s.ios.deployment_target = '15.0'

  # Point to your Swift sources inside the package
  s.source_files     = 'Sources/**/*.{swift}'

  # If you have resources (images, nibs, etc.)
  # s.resources      = 'Sources/SwiftyWidgets/Resources/**/*'
end
