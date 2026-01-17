class SmartRename < Formula
  desc "AI-powered file renaming tool that generates intelligent, descriptive filenames"
  homepage "https://github.com/tigger04/smart-rename"
  url "https://github.com/tigger04/smart-rename/archive/b6007ca88439c3a254c65cd8f98ae3e35fe647fb.tar.gz"
  sha256 "6bcd1f4aceb6e0f28c346ef3fcda4727e066598ab7b73c71b07a89d2b1cc3f23"
  license "MIT"
  version "1.0.2-dev"

  depends_on "bash"
  depends_on "curl"
  depends_on "fd"
  depends_on "jq"
  depends_on "ollama"
  depends_on "pandoc"

  def install
    # Install main executable
    bin.install "smart-rename"

    # Install library
    (share/"smart-rename").install "summarize-text-lib.sh"

    # Install config examples
    (share/"smart-rename").install "config.example"
    (share/"smart-rename").install "config.example.yaml"

    # Update the script to use the correct library path
    inreplace bin/"smart-rename",
      'source "$script_dir/summarize-text-lib.sh"',
      "source \"#{share}/smart-rename/summarize-text-lib.sh\""
  end

  def post_install
    # Create config directory
    config_dir = "#{ENV["HOME"]}/.config/smart-rename"
    config_file = "#{config_dir}/config.yaml"

    # Only create default config if it doesn't exist
    unless File.exist?(config_file)
      FileUtils.mkdir_p(config_dir)
      FileUtils.cp("#{share}/smart-rename/config.example.yaml", config_file)
    end

    # Start Ollama service and pull mistral model
    system "brew services start ollama"
    system "ollama pull mistral"
  end

  def caveats
    <<~EOS
      A default configuration file has been created at:
        ~/.config/smart-rename/config.yaml

      smart-rename is ready to use with Ollama (mistral model) installed locally.

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