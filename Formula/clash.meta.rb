class ClashMeta < Formula
  desc "Rule-based tunnel in Go"
  homepage "https://wiki.metacubex.one"
  url "https://github.com/MetaCubeX/Clash.Meta/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "037f926369ac9a0922801f1b0a8e2d79d454e67f6bc2a1e4ca7a52a0a8c641ea"
  license "GPL-3.0-only"

  depends_on "go" => :build

  def install
    build_time = Time.now.utc.strftime("%a %b %d %H:%M:%S UTC %Y")
    ldflags = "-s -w -X 'github.com/Dreamacro/clash/constant.Version=#{version}' -X 'github.com/Dreamacro/clash/constant.BuildTime=#{build_time}' -buildid="
    tags = "with_gvisor"
    system "go", "build", "-tags", tags, *std_go_args(ldflags:)
  end

  def post_install
    (etc/"clash.meta").mkpath
  end

  service do
    run [opt_bin/"clash.meta", "-d", etc/"clash.meta"]
    keep_alive true
    error_log_path var/"log/clash.meta.log"
    log_path var/"log/clash.meta.log"
  end

  test do
    system "#{bin}/clash.meta", "-v"
  end
end
