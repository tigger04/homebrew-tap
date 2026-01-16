class SmartRename < Formula
  desc "AI-powered file renaming tool that generates intelligent, descriptive filenames"
  homepage "https://github.com/tigger04/smart-rename"
  url "https://github.com/tigger04/smart-rename/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "placeholder_sha256_will_be_updated_after_release"
  license "MIT"

  depends_on "bash"
  depends_on "jq"
  depends_on "curl"

  def install
    # Install main executable
    bin.install "smart-rename"

    # Install library
    (share/"smart-rename").install "summarize-text-lib.sh"

    # Install config example
    (share/"smart-rename").install "config.example"

    # Update the script to use the correct library path
    inreplace bin/"smart-rename",
      'source "$(dirname "$0")/summarize-text-lib.sh"',
      "source \"#{share}/smart-rename/summarize-text-lib.sh\""
  end

  def caveats
    <<~EOS
      To configure smart-rename, copy the example config:
        cp #{share}/smart-rename/config.example ~/.config/smart-rename/config

      Then edit it with your API keys:
        nano ~/.config/smart-rename/config

      You'll need at least one of:
        - OpenAI API key
        - Claude API key
        - Ollama running locally
    EOS
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/smart-rename --help 2>&1")
  end
end