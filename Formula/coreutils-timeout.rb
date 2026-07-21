# typed: false
# frozen_string_literal: true

class CoreutilsTimeout < Formula
  desc "Provides unprefixed timeout command from GNU coreutils"
  homepage "https://www.gnu.org/software/coreutils/"
  url "https://raw.githubusercontent.com/wow-look-at-my-code/homebrew-ext-pkgs/main/sources/coreutils-timeout/VERSION"
  version "1.0"
  sha256 "5717e7c840171019a4eeab5b79a7f894a4986eaff93d04ec5b12c9a189f594bf"
  license "GPL-3.0-or-later"

  depends_on "coreutils"

  def install
    bin.install_symlink Formula["coreutils"].opt_bin/"gtimeout" => "timeout"
  end

  test do
    system bin/"timeout", "--version"
  end
end
