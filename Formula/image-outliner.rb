class ImageOutliner < Formula
  desc "Convert bitmap images to clean monochrome vector outlines"
  homepage "https://github.com/tigger04/image-outliner"
  url "https://github.com/tigger04/image-outliner/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "540e95cc56838f32fc84034f2fff634a12f35687c1637d3953296266c0fedfdc"
  license "MIT"

  depends_on "python@3.12"
  depends_on "potrace"

  def install
    # Create virtualenv and install package
    venv = libexec/"venv"
    system "python3.12", "-m", "venv", venv
    venv_pip = venv/"bin/pip"
    system venv_pip, "install", "--upgrade", "pip"
    system venv_pip, "install", buildpath

    # Create wrapper script
    (bin/"outline").write <<~EOS
      #!/bin/bash
      exec "#{venv}/bin/outline" "$@"
    EOS
  end

  def caveats
    <<~EOS
      Usage:
        outline input.jpg -o output.svg
        outline ./photos/ -o ./outlines/

      For development with visual test output:
        brew install timg
    EOS
  end

  test do
    # Test help works
    assert_match "Usage:", shell_output("#{bin}/outline --help")

    # Test version
    assert_match "0.6.0", shell_output("#{bin}/outline --version")
  end
end
