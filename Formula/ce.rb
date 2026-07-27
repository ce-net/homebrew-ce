# Homebrew formula for CE.
# Tap:     brew tap ce-net/ce
# Install: brew install ce
#
# SHA256 values are updated by packaging/scripts/update-sha256.sh in the ce repo after each release.
class Ce < Formula
  desc "Peer-to-peer compute mesh and economy"
  homepage "https://github.com/ce-net/ce"
  version "0.1.33"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ce-net/ce/releases/download/v#{version}/ce-macos-arm64.tar.gz"
      sha256 "20879439975556cf281568d2d6084c3b518655a353f5586b9320b7b0bbcab423"
    else
      odie "ce ships no Intel-Mac binary. Build from source (cargo build --release) or run: curl -sSL https://ce-net.com/install.sh | bash"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ce-net/ce/releases/download/v#{version}/ce-linux-arm64.tar.gz"
      sha256 "04e8bd17348350cc5b5bfbded96f1542043f231f792a55d0d89ae525b99d2ef3"
    else
      url "https://github.com/ce-net/ce/releases/download/v#{version}/ce-linux-amd64.tar.gz"
      sha256 "00bd39853d3e11b97387e60e6085d250e2c16dce1aa37d60a011bc2b5268f0db"
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
