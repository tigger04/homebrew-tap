class SmartRename < Formula
  desc "AI-powered file renaming tool that generates intelligent, descriptive filenames"
  homepage "https://github.com/tigger04/smart-rename"
  url "https://raw.githubusercontent.com/tigger04/smart-rename/v5.21.3/smart-rename"
  sha256 "dabbdc905cf94d3009b942e2c4a523e0eb71214529a11eb03202939f711cd5a8"
  license "MIT"
  version "5.21.3"

  depends_on "bash"
  depends_on "curl"
  depends_on "fd"
  depends_on "jq"
  depends_on "yq"
  depends_on "ollama"
  depends_on "poppler"

  def install
    bin.install "smart-rename"
  end

  def caveats
    <<~EOS
      Configuration:
        smart-rename will create a default config on first run at:
        ~/.config/smart-rename/config.yaml

      First run:
        Start Ollama: brew services start ollama
        The Ollama model will be downloaded automatically on first use.

      For enhanced AI capabilities, optionally add API keys either:
        1. In the config file: nano ~/.config/smart-rename/config.yaml
        2. As environment variables: export OPENAI_API_KEY="sk-..."

      Available AI providers:
        - Ollama (auto-pulls model on first use)
        - OpenAI API (OPENAI_API_KEY) - optional
        - Claude API (CLAUDE_API_KEY) - optional
    EOS
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/smart-rename --help 2>&1")
  end
end