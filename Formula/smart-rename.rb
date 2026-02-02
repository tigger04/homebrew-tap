class SmartRename < Formula
  desc "AI-powered file renaming tool that generates intelligent, descriptive filenames"
  homepage "https://github.com/tigger04/smart-rename"
  url "https://github.com/tigger04/smart-rename/archive/refs/tags/v5.23.8.tar.gz"
  sha256 "a26ace4490644766484032335295dfb414ed4a46d5b5d2e0f46cf6aa40cbbdb6"
  license "MIT"
  version "5.23.8"

  depends_on "bash"
  depends_on "curl"
  depends_on "fd"
  depends_on "jq"
  depends_on "yq"
  depends_on "poppler"

  def install
    bin.install "smart-rename"
    (pkgshare).install "config.example.yaml"
    (pkgshare).install "smart-rename.Modelfile"
    inreplace bin/"smart-rename",
      'SMART_RENAME_SHARE_DIR="${SMART_RENAME_SHARE_DIR:-}"',
      "SMART_RENAME_SHARE_DIR=\"#{pkgshare}\""
  end

  def caveats
    <<~EOS
      smart-rename works out of the box with sensible defaults.

      Optionally create a custom config:
        cp #{pkgshare}/config.example.yaml ~/.config/smart-rename/config.yaml
        nano ~/.config/smart-rename/config.yaml

      First run (with Ollama):
        brew install ollama
        brew services start ollama
        The custom model will be created automatically on first use.

      For cloud AI, set API keys:
        export OPENAI_API_KEY="sk-..."    # OpenAI
        export CLAUDE_API_KEY="sk-ant-..."  # Claude

      Default provider order: Ollama -> OpenAI -> Claude
      Configure in ~/.config/smart-rename/config.yaml
    EOS
  end

  test do
    assert_match "USAGE:", shell_output("#{bin}/smart-rename --help 2>&1")
    assert_match version.to_s, shell_output("#{bin}/smart-rename --version 2>&1")
  end
end
