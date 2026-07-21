# typed: false
# frozen_string_literal: true

class GlibcAT241 < Formula
  desc "GNU C Library"
  homepage "https://www.gnu.org/software/libc/"
  url "https://ftp.gnu.org/gnu/glibc/glibc-2.41.tar.xz"
  sha256 "a5a26b22f545d6b7d7b3dd828e11e428f24f4fac43c934fb071b6a7d0828e901"
  license "LGPL-2.1-or-later"

  depends_on "bison" => :build
  depends_on "gawk" => :build
  depends_on "linux-headers@5.15" => :build
  depends_on "m4" => :build
  depends_on "make" => :build
  depends_on "python@3" => :build
  depends_on :linux

  def install
    # Clean up environment to prevent conflicts with glibc build
    # (following homebrew-core's glibc formula approach)
    %w[LDFLAGS LD_LIBRARY_PATH LD_RUN_PATH LIBRARY_PATH
       HOMEBREW_DYNAMIC_LINKER HOMEBREW_LIBRARY_PATHS HOMEBREW_RPATH_PATHS
       CFLAGS CXXFLAGS CPPFLAGS].each { |x| ENV.delete x }

    # Use system gcc directly to avoid Homebrew's compiler wrapper
    ENV["CC"] = "/usr/bin/gcc"
    ENV["CXX"] = "/usr/bin/g++"

    mkdir "build" do
      args = %W[
        --disable-debug
        --disable-dependency-tracking
        --disable-silent-rules
        --prefix=#{prefix}
        --enable-kernel=4.4.0
        --disable-werror
        --enable-stack-protector=strong
        --with-headers=#{Formula["linux-headers@5.15"].include}
        --disable-nscd
      ]

      system "../configure", *args, "CFLAGS=-O2", "CXXFLAGS=-O2"
      system "make"
      system "make", "install"
    end
  end

  test do
    # Test that the dynamic linker works
    assert_match "Usage", shell_output("#{bin}/ld.so --help")
    # Test that libc.so.6 can report its version
    safe_system lib/"libc.so.6", "--version"
    # Test that locale utility works
    safe_system bin/"locale", "--version"
  end
end
