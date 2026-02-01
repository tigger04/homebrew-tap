class RealEsrganPro < Formula
  desc "AI image and video upscaler — CLI wrapper around Real-ESRGAN"
  homepage "https://github.com/tigger04/Real-ESRGAN"
  url "https://github.com/tigger04/Real-ESRGAN/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "93210c0e8bd11c3ca17dd8e4577d5dfba78ef20ab9e60c1654751d565d4699fe"
  license "BSD-3-Clause"
  version "0.4.0"

  depends_on "python@3.12"
  depends_on "ffmpeg"

  def install
    venv = libexec/"venv"
    system "python3.12", "-m", "venv", venv
    venv_pip = venv/"bin/pip"
    system venv_pip, "install", "--upgrade", "pip"
    system venv_pip, "install", buildpath

    (bin/"upscale").write <<~EOS
      #!/bin/bash
      exec "#{venv}/bin/upscale" "$@"
    EOS

    (bin/"upscale-video").write <<~EOS
      #!/bin/bash
      exec "#{venv}/bin/upscale-video" "$@"
    EOS
  end

  def caveats
    <<~EOS
      Usage:
        upscale -i input.jpg -o output/
        upscale-video -i input.mp4 -o output/

      Models are downloaded automatically on first use to:
        ~/.cache/realesrgan/weights/

      Override with: export REALESRGAN_WEIGHTS_DIR=/path/to/weights

      On Apple Silicon (no CUDA), you may need --fp32 for some models.
    EOS
  end

  test do
    assert_match "usage", shell_output("#{bin}/upscale --help").downcase
    assert_match "0.3.0", shell_output("#{bin}/upscale --version")
  end
end
