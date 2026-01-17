class SmartRename < Formula
  desc "AI-powered file renaming tool that generates intelligent, descriptive filenames"
  homepage "https://github.com/tigger04/smart-rename"
  url "https://raw.githubusercontent.com/tigger04/smart-rename/v5.13.0/smart-rename"
  sha256 "e5ed1dda56a4516bbb818f31ff655a8493750844ce07508683fcf163aed894af"
  license "MIT"
  version "5.13.0"

  depends_on "bash"
  depends_on "curl"
  depends_on "fd"
  depends_on "jq"
  depends_on "yq"
  depends_on "ollama"
  depends_on "poppler"

  def install
    # Install main executable
    bin.install "smart-rename"

    # Download and install config file
    system "curl", "-L", "-o", "config.yaml", "https://raw.githubusercontent.com/tigger04/smart-rename/v#{version}/config.yaml"
    (share/"smart-rename").install "config.yaml"
  end

  def post_install
    # Create config directory
    config_dir = "#{ENV["HOME"]}/.config/smart-rename"
    config_file = "#{config_dir}/config.yaml"

    # Only create default config if it doesn't exist
    unless File.exist?(config_file)
      FileUtils.mkdir_p(config_dir)
      FileUtils.cp("#{share}/smart-rename/config.yaml", config_file)
    end

    # Start Ollama service and pull mistral model
    system "brew services start ollama"
    system "ollama pull mistral"
  end

  def caveats
    <<~EOS
      Configuration:
        smart-rename will create a default config on first run at:
        ~/.config/smart-rename/config.yaml

      smart-rename is ready to use with Ollama (mistral model).

      For enhanced AI capabilities, optionally add API keys either:
        1. In the config file: nano ~/.config/smart-rename/config.yaml
        2. As environment variables: export OPENAI_API_KEY="sk-..."

      Available AI providers:
        - Ollama (mistral model) - installed and ready
        - OpenAI API (OPENAI_API_KEY) - optional
        - Claude API (CLAUDE_API_KEY) - optional

      smart-rename works out of the box with Ollama, or with added API keys.
    EOS
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/smart-rename --help 2>&1")
  end
end