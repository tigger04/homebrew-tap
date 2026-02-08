# ABOUTME: Homebrew cask for bg-clock desktop analogue clock.
# Installs the app bundle to ~/Applications.

cask "bg-clock" do
  version "0.1.0"
  sha256 :no_check

  url "https://github.com/tigger04/bg-clock/releases/download/v#{version}/BGClock-#{version}.zip"
  name "bg-clock"
  desc "Analogue clock rendered on the macOS desktop background"
  homepage "https://github.com/tigger04/bg-clock"

  depends_on macos: ">= :sonoma"

  app "BGClock.app"

  zap trash: [
    "~/.config/bg-clock",
    "~/Library/LaunchAgents/dev.tigger.bg-clock.plist",
  ]

  caveats <<~EOS
    To launch at login:
      make launchd-install
    Or manually load the launch agent:
      launchctl load ~/Library/LaunchAgents/dev.tigger.bg-clock.plist

    Configuration: ~/.config/bg-clock/config.json
  EOS
end
