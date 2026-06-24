class Smctl < Formula
  desc "Control your Mac's SMC: fan curves, battery charge limits, power telemetry"
  homepage "https://github.com/leaperone/smctl"
  url "https://github.com/leaperone/smctl/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "a49520e455677c29af0da44c7195be50f538f1f02cf41a89d18cfc849ab65fc2"
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
