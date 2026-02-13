class StoryboardGen < Formula
  desc "Generate video stills and clips from a YAML storyboard using AI providers"
  homepage "https://github.com/tigger04/storyboard-gen"
  url "https://github.com/tigger04/storyboard-gen/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "bd6f28cddcce728a788a326b6efd0344b34a13849f9e511f4bd5d275c09f4b7b"
  license "MIT"

  depends_on "python@3.12"
  depends_on "ffmpeg"

  def install
    # Create virtualenv and install package with all Python dependencies
    venv = libexec/"venv"
    system "python3.12", "-m", "venv", venv
    venv_pip = venv/"bin/pip"
    system venv_pip, "install", "--upgrade", "pip"
    system venv_pip, "install", "#{buildpath}[all]"

    # Create wrapper script
    (bin/"storyboard-gen").write <<~EOS
      #!/bin/bash
      exec "#{venv}/bin/storyboard-gen" "$@"
    EOS
  end

  def caveats
    <<~EOS
      storyboard-gen requires Google Cloud credentials to generate images/video.

      Setup:
        1. Install Google Cloud SDK: brew install google-cloud-sdk
        2. Authenticate: gcloud auth application-default login
        3. Create a .env in your project directory:

           USE_VERTEX=true
           GOOGLE_CLOUD_PROJECT=your-project-id
           GOOGLE_CLOUD_LOCATION=us-central1
           GCS_OUTPUT_BUCKET=gs://your-bucket-name/

      Then create a project.yaml and run:
        storyboard-gen validate
        storyboard-gen generate --all
        storyboard-gen assemble
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/storyboard-gen --version")
  end
end
