class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.2.7.tar.gz", using: :homebrew_curl
  sha256 "49b829f4cf148b59789eeaf8d01987e7526a44d0290cf608a6350c57562ae177"
  license "GPL-3.0-or-later"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} -buildid="
    tags = "with_gvisor,with_quic,with_wireguard,with_utls,with_reality_server,with_clash_api"
    system "go", "build", "-tags", tags, *std_go_args(ldflags: ldflags), "./cmd/sing-box"
  end

  def post_install
    (etc/"sing-box").mkpath
    (var/"sing-box").mkpath
  end

  service do
    run [opt_bin/"sing-box", "run", "-C", etc/"sing-box"]
    keep_alive true
    working_dir var/"sing-box"
    error_log_path var/"log/sing-box.log"
    log_path var/"log/sing-box.log"
  end

  test do
    system "#{bin}/sing-box", "version"
  end
end
