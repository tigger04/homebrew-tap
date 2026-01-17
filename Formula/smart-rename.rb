class SmartRename < Formula
  desc "AI-powered file renaming tool that generates intelligent, descriptive filenames"
  homepage "https://github.com/tigger04/smart-rename"
  url "https://github.com/tigger04/smart-rename/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "placeholder_sha256_will_be_updated_after_release"
  license "MIT"

  depends_on "bash"
  depends_on "curl"
  depends_on "jq"
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
      'source "$(dirname "$0")/summarize-text-lib.sh"',
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
  end

  def caveats
    <<~EOS
      A default configuration file has been created at:
        ~/.config/smart-rename/config.yaml

      To use smart-rename, add your API keys to the config file:
        nano ~/.config/smart-rename/config.yaml

      You'll need at least one of:
        - OpenAI API key
        - Claude API key
        - Ollama running locally

      smart-rename will work with default settings once you add your API keys.
    EOS
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/smart-rename --help 2>&1")
  end
end