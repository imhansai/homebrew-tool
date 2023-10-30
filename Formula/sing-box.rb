class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.5.5.tar.gz", using: :homebrew_curl
  sha256 "ddb599acc2c7ce99bec22bbae96f054b4f7193916b61c641743a3a52b15766f4"
  license "GPL-3.0-or-later"

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "sing-box"
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
