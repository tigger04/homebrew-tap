# Additional metadata in README of tap repo.

cask "clockfloat" do
  version "1.0"
  sha256 "43920a3a4fa487b0764a6228306035a765dbf97be4474811695d29ed8472b917"

  url "https://github.com/tigger04/clockfloat/releases/download/v#{version}/clockfloat-#{version}.zip"
  name "clockfloat"
  desc "Floating digital clock for macOS"
  homepage "https://github.com/tigger04/clockfloat"

  depends_on macos: ">= :ventura"

  app "clockfloat.app"

  zap trash: [
    "~/Library/Preferences/ie.tigger.clock.clockfloat.plist",
  ]

  caveats <<~EOS
    Configure font, corner, and dodge behavior:
      defaults write ie.tigger.clock.clockfloat ClockFontName "White Rabbit"
      defaults write ie.tigger.clock.clockfloat ClockInitialCorner "bottomRight"
      defaults write ie.tigger.clock.clockfloat ClockDodgesMouse -bool true

    Run `make release` in the main repo before updating this cask so the
    referenced zip exists and the SHA256 can be captured (replace :no_check).
  EOS
end
