# typed: false
# frozen_string_literal: true

class BatsAssert < Formula
  desc "Common assertions for Bats (Bash Automated Testing System)"
  homepage "https://github.com/bats-core/bats-assert"
  url "https://github.com/bats-core/bats-assert/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "e305df20c4c36cba4570e10f1cd824efb1ae71d88b5ef474550781ebee04192f"
  license "CC0-1.0"

  depends_on "bats-core"
  depends_on "bats-support"

  def install
    (lib/"bats/bats-assert").install Dir["*"]
  end

  def caveats
    <<~EOS
      Sorry, Homebrew can't write to /usr/lib/bats, so manual setup is required.

      Option 1: Add to your shell profile:
        export BATS_LIB_PATH="#{HOMEBREW_PREFIX}/lib/bats${BATS_LIB_PATH:+:$BATS_LIB_PATH}"

      Option 2: Symlink to the default BATS_LIB_PATH (requires sudo):
        sudo mkdir -p /usr/lib/bats
        sudo ln -s #{HOMEBREW_PREFIX}/lib/bats/bats-assert /usr/lib/bats/bats-assert

      Then in your test files:
        bats_load_library bats-support
        bats_load_library bats-assert
    EOS
  end

  test do
    assert_predicate lib/"bats/bats-assert/load.bash", :exist?
  end
end
