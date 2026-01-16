class PolishText < Formula
  desc "AI-powered text enhancement tool that improves clarity and professionalism"
  homepage "https://github.com/tigger04/polish-text"
  url "https://github.com/tigger04/polish-text/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "placeholder_sha256_will_be_updated_after_release"
  license "MIT"

  depends_on "bash"
  depends_on "jq"
  depends_on "curl"

  def install
    # Install main executable
    bin.install "polish-text"

    # Install library
    (share/"polish-text").install "summarize-text-lib.sh"

    # Install config example
    (share/"polish-text").install "config.example"

    # Update the script to use the correct library path
    inreplace bin/"polish-text",
      'source "$(dirname "$0")/summarize-text-lib.sh"',
      "source \"#{share}/polish-text/summarize-text-lib.sh\""
  end

  def caveats
    <<~EOS
      To configure polish-text, copy the example config:
        cp #{share}/polish-text/config.example ~/.config/polish-text/config

      Then edit it with your API keys:
        nano ~/.config/polish-text/config

      You'll need at least one of:
        - OpenAI API key
        - Claude API key
        - Ollama running locally
    EOS
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/polish-text --help 2>&1")
  end
end