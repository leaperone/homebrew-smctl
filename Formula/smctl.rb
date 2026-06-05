class Smctl < Formula
  desc "Control your Mac's SMC: fan curves, battery charge limits, power telemetry"
  homepage "https://github.com/leaperone/smctl"
  url "https://github.com/leaperone/smctl/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "1d154c9a2d1642cb62dad8d01bf813cffb6c3235f0a8c92ec0df1a622fbc59f5"
  license "MIT"
  head "https://github.com/leaperone/smctl.git", branch: "main"

  depends_on :macos
  depends_on xcode: ["16.0", :build]

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/smctl"
    # smctl daemon install locates smctld next to the smctl binary.
    bin.install ".build/release/smctld"
  end

  def caveats
    <<~EOS
      Reading sensors works out of the box:
        smctl sensors

      Battery and fan control need the privileged daemon:
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
