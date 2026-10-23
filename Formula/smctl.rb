class Smctl < Formula
  desc "Control your Mac's SMC: fan curves, battery charge limits, power telemetry"
  homepage "https://github.com/leaperone/smctl"
  url "https://github.com/leaperone/smctl/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "194c1c1ac5c15d61a283101f2e3fbf513aba1d58b02c8b38b9572f9604d992c4"
  license "MIT"
  head "https://github.com/leaperone/smctl.git", branch: "main"

  depends_on :macos
  depends_on xcode: ["16.0", :build]

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/smctl"
    # smctl daemon install locates smctld next to the smctl binary.
    bin.install ".build/release/smctld"

    man1.install "docs/smctl.1"

    generate_completions_from_executable(
      bin/"smctl", "--generate-completion-script",
      shells: [:bash, :zsh, :fish],
      shell_parameter_format: :none
    )
  end

  def caveats
    <<~EOS
      Reading sensors works out of the box:
        smctl sensors

      Battery and fan control need the privileged daemon:
        sudo smctl daemon install

      After every upgrade, update the protected helper and restart the service:
        sudo smctl daemon install

      To remove everything cleanly (restores system control of fans/charging):
        sudo smctl daemon uninstall
        brew uninstall smctl
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/smctl --version")
  end
end
