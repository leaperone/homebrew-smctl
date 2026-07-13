class Smctl < Formula
  desc "Control your Mac's SMC: fan curves, battery charge limits, power telemetry"
  homepage "https://github.com/leaperone/smctl"
  url "https://github.com/leaperone/smctl/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "77fcada1a1f64ae8e2e5f84bfbdd86b63a98abb1b10b8a937b72615ad8800636"
  license "MIT"
  head "https://github.com/leaperone/smctl.git", branch: "main"

  depends_on :macos
  uses_from_macos "swift" => :build

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

      IMPORTANT — after every upgrade, restart the daemon so the new version
      actually takes effect (upgrades swap binaries but never restart it):
        sudo smctl daemon restart

      To remove everything cleanly (restores system control of fans/charging):
        sudo smctl daemon uninstall
        brew uninstall smctl
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/smctl --version")
  end
end
