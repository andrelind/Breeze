Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.name         = "Breeze"
  s.version      = "0.0.1"
  s.summary      = "Breeze is a lightweight CoreData manager written in Swift!"

  s.description  = <<-DESC
                   Breeze takes a lot of cues from both [MagicalRecord](https://github.com/magicalpanda/MagicalRecord) and [Nimble](https://github.com/MarcoSero/Nimble)

                   * Lightweight and simple to use
                   * 1 row of code to find first/any object in database
                   * iCloud support
                   * Simple architecture using only a main and a background context.
                   DESC

  s.homepage     = "https://github.com/andrelind/Breeze"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license      = { :type => "MIT", :file => "https://github.com/andrelind/Breeze/blob/master/LICENSE" }

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author             = "André Lind"
  s.social_media_url   = "http://twitter.com/FixingKitty"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform     = :ios, "7.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :git => "https://github.com/andrelind/Breeze.git", :tag => "0.0.1" }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files  = "Breeze", "Breeze/**/*.{h,m,swift}"
  s.exclude_files = "Breeze/Exclude"

  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.framework  = "CoreData"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.requires_arc = true

end
