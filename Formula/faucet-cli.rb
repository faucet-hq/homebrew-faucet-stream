class FaucetCli < Formula
  desc "Config-driven CLI runner for faucet-stream pipelines (YAML / JSON, Meltano-style)"
  homepage "https://faucet-hq.github.io/faucet-stream/"
  version "1.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/faucet-hq/faucet-stream/releases/download/faucet-cli-v1.12.0/faucet-cli-aarch64-apple-darwin.tar.xz"
      sha256 "9e19e31632daf873ebad0d6a0ae033bf4dc42848f9878bb3ff4223aad94061a6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/faucet-hq/faucet-stream/releases/download/faucet-cli-v1.12.0/faucet-cli-x86_64-apple-darwin.tar.xz"
      sha256 "2ef9dc61d46bbe962433f551136c793245fbd31d8b2c52576765c87895794fb7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/faucet-hq/faucet-stream/releases/download/faucet-cli-v1.12.0/faucet-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c14df7cbdd212749e52903979176db6974b89d907ca239d200c92e30473efa14"
    end
    if Hardware::CPU.intel?
      url "https://github.com/faucet-hq/faucet-stream/releases/download/faucet-cli-v1.12.0/faucet-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2b5c81e7146f2c954c65ff0cadbc539b59ad7d51bbf5bc871eb7a9b6ae68e919"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "faucet"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "faucet"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "faucet"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "faucet"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
