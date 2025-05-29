class Smali < Formula
  desc "Assembler/disassembler for Android's Java VM implementation"
  homepage "https://github.com/imhansai/smali"
  url "https://github.com/imhansai/smali/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "a7c190843fcbcca2a2cef827856f7c144ecc929d4303940f36c36ffa53c2c0aa"
  license "BSD-3-Clause"

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    system "gradle", "build", "--no-daemon"

    %w[smali baksmali].each do |name|
      jarfile = "#{name}-#{version}-dev-fat.jar"

      libexec.install "#{name}/build/libs/#{jarfile}"
      bin.write_jar_script libexec/jarfile, name
    end
  end

  test do
    # From examples/HelloWorld/HelloWorld.smali in Smali project repo.
    # See https://bitbucket.org/JesusFreke/smali/src/2d8cbfe6bc2d8ff2fcd7a0bf432cc808d842da4a/examples/HelloWorld/HelloWorld.smali?at=master
    (testpath/"input.smali").write <<~EOS
      .class public LHelloWorld;
      .super Ljava/lang/Object;

      .method public static main([Ljava/lang/String;)V
        .registers 2
        sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;
        const-string v1, "Hello World!"
        invoke-virtual {v0, v1}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V
        return-void
      .end method
    EOS

    system bin/"smali", "assemble", "-o", "classes.dex", "input.smali"
    system bin/"baksmali", "disassemble", "-o", pwd, "classes.dex"
    assert_match "Hello World!", File.read("HelloWorld.smali")
  end
end
