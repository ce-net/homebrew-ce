# Homebrew formula for CE.
# Tap:     brew tap ce-net/ce
# Install: brew install ce
#
# SHA256 values are updated by packaging/scripts/update-sha256.sh in the ce repo after each release.
class Ce < Formula
  desc "Peer-to-peer compute mesh and economy"
  homepage "https://github.com/ce-net/ce"
  version "0.1.35"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ce-net/ce/releases/download/v#{version}/ce-macos-arm64.tar.gz"
      sha256 "57cebc8fdeaea5b15f9de31bf55c40b146c0525908286ad1524e0276c3c1063c"
    else
      odie "ce ships no Intel-Mac binary. Build from source (cargo build --release) or run: curl -sSL https://ce-net.com/install.sh | bash"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ce-net/ce/releases/download/v#{version}/ce-linux-arm64.tar.gz"
      sha256 "87e05c5f050cec78ed3ed1234b677563edcd56d7024a3dca9115268562c3a034"
    else
      url "https://github.com/ce-net/ce/releases/download/v#{version}/ce-linux-amd64.tar.gz"
      sha256 "10042f1aa672ea7849282cbc32f08d06c5309a4833ece0c2df60bd799cb0923c"
    end
  end

  def install
    bin.install "ce"
  end

  service do
    run [opt_bin/"ce", "start"]
    keep_alive true
    log_path var/"log/ce.log"
    error_log_path var/"log/ce.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ce --version")
  end
end
