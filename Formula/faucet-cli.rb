class FaucetCli < Formula
  desc "Config-driven CLI runner for faucet-stream pipelines (YAML / JSON, Meltano-style)"
  homepage "https://faucet-hq.github.io/faucet-stream/"
  version "1.17.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/faucet-hq/faucet-stream/releases/download/faucet-cli-v1.17.0/faucet-cli-aarch64-apple-darwin.tar.xz"
      sha256 "5d186ae1cea7c56f4c690d34ae1a5311f0ac62dbe77ae307fdbbc6393b4f84c8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/faucet-hq/faucet-stream/releases/download/faucet-cli-v1.17.0/faucet-cli-x86_64-apple-darwin.tar.xz"
      sha256 "9dc49fa5e9fa8ffcfaf45bd0498bded1dca9c75a3a8033261f1c29c4ea8d4843"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/faucet-hq/faucet-stream/releases/download/faucet-cli-v1.17.0/faucet-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "eb46d5c3f91bbb7f1dca04623f535969516960d2b238aa7b06aa62e78e2ab0c7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/faucet-hq/faucet-stream/releases/download/faucet-cli-v1.17.0/faucet-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "99d4ffc8626693affa9c545cd5e014ad0e436fd725487371e44fc213c2832869"
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
