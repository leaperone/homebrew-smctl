class Smctl < Formula
  desc "Control your Mac's SMC: fan curves, battery charge limits, power telemetry"
  homepage "https://github.com/leaperone/smctl"
  url "https://github.com/leaperone/smctl/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "91836790c8884311021c8c43b68b8e995113a82042c7a68a9a1e42746f55671f"
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
