class Mihomo < Formula
  desc "Simple Python Pydantic model for Honkai"
  homepage "https://wiki.metacubex.one/"
  url "https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "9713035bd2c3553588cd9151574f70b6803dc90a4aa65b0506429376675da22a"
  license "MIT"

  depends_on "go" => :build

  def install
    build_time = Time.now.utc.strftime("%a %b %d %H:%M:%S UTC %Y")
    ldflags = "-s -w -X 'github.com/metacubex/mihomo/constant.Version=#{version}' -X 'github.com/metacubex/mihomo/constant.BuildTime=#{build_time}' -buildid="
    tags = "with_gvisor"
    system "go", "build", "-tags", tags, *std_go_args(ldflags:)
  end

  def post_install
    (etc/"mihomo").mkpath
  end

  service do
    run [opt_bin/"mihomo", "-d", etc/"mihomo"]
    keep_alive true
    error_log_path var/"log/mihomo.log"
    log_path var/"log/mihomo.log"
  end

  test do
    system "#{bin}/mihomo", "-v"
  end
end
