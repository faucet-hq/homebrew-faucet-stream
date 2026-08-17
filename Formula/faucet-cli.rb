class FaucetCli < Formula
  desc "Config-driven CLI runner for faucet-stream pipelines (YAML / JSON, Meltano-style)"
  homepage "https://faucet-hq.github.io/faucet-stream/"
  version "1.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/faucet-hq/faucet-stream/releases/download/faucet-cli-v1.10.0/faucet-cli-aarch64-apple-darwin.tar.xz"
      sha256 "f0ef0c7279f3d965f7fe54843e6fc96ff7311fa2eab9a52ad4bb7998de26a0d4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/faucet-hq/faucet-stream/releases/download/faucet-cli-v1.10.0/faucet-cli-x86_64-apple-darwin.tar.xz"
      sha256 "76b222bba90c63ee83275aeb538f382bfa35b3b52e96a48f92123f71139bad50"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/faucet-hq/faucet-stream/releases/download/faucet-cli-v1.10.0/faucet-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d0f7a8578fe9074ce73153dcc02891275462c577693d371b2577a55c28babd01"
    end
    if Hardware::CPU.intel?
      url "https://github.com/faucet-hq/faucet-stream/releases/download/faucet-cli-v1.10.0/faucet-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "479b65df8500cf1a0bb8a5f533da4af6beb4886e833dd2252b65deb83518efd8"
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
