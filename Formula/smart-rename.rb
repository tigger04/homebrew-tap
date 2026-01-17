class SmartRename < Formula
  desc "AI-powered file renaming tool that generates intelligent, descriptive filenames"
  homepage "https://github.com/tigger04/smart-rename"
  url "https://raw.githubusercontent.com/tigger04/smart-rename/v5.18.0/smart-rename"
  sha256 "fbad87b32e0c8853a2788abf96ac6182fb76814b275cc3863204366dae9af982"
  license "MIT"
  version "5.18.0"

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
    config_dir = Pathname.new(Dir.home)/".config/smart-rename"
    config_file = config_dir/"config.yaml"
    source_config = prefix/"share/smart-rename/config.yaml"

    # Only create default config if it doesn't exist
    unless config_file.exist?
      config_dir.mkpath
      FileUtils.cp(source_config, config_file) if source_config.exist?
    end
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