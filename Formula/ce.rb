# Homebrew formula for CE.
# Tap:     brew tap ce-net/ce
# Install: brew install ce
#
# SHA256 values are updated by packaging/scripts/update-sha256.sh in the ce repo after each release.
class Ce < Formula
  desc "Peer-to-peer compute mesh and economy"
  homepage "https://github.com/ce-net/ce"
  version "0.1.34"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ce-net/ce/releases/download/v#{version}/ce-macos-arm64.tar.gz"
      sha256 "3805aef9be39f3f9658ef6378f780f54fef5972965e81f85d63bba2a3c4de2e8"
    else
      odie "ce ships no Intel-Mac binary. Build from source (cargo build --release) or run: curl -sSL https://ce-net.com/install.sh | bash"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ce-net/ce/releases/download/v#{version}/ce-linux-arm64.tar.gz"
      sha256 "c840779116a62886e4ea765f2826c58ab9e49db74a07c4cecc4869cd2468cef9"
    else
      url "https://github.com/ce-net/ce/releases/download/v#{version}/ce-linux-amd64.tar.gz"
      sha256 "43329c84120b45be4745627682a487df3806e08af99075c6cd8f76d1d5f9cb76"
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
