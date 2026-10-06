class FaucetCli < Formula
  desc "Config-driven CLI runner for faucet-stream pipelines (YAML / JSON, Meltano-style)"
  homepage "https://faucet-hq.github.io/faucet-stream/"
  version "1.13.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/faucet-hq/faucet-stream/releases/download/faucet-cli-v1.13.2/faucet-cli-aarch64-apple-darwin.tar.xz"
      sha256 "c8a14656c1a989280405a571789b5c6cde03c8313da9d77f58291e0a8c466f65"
    end
    if Hardware::CPU.intel?
      url "https://github.com/faucet-hq/faucet-stream/releases/download/faucet-cli-v1.13.2/faucet-cli-x86_64-apple-darwin.tar.xz"
      sha256 "5b638d5b13af7dc4375edf52f0603eacdcae0c6e5d291f4b6603801bf844c015"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/faucet-hq/faucet-stream/releases/download/faucet-cli-v1.13.2/faucet-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b0c33e21a044b160607d4930da13a4111b39eecc571f5d2ea406f4544d26b6e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/faucet-hq/faucet-stream/releases/download/faucet-cli-v1.13.2/faucet-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4a36b9f99b52b4b2c78a0a436b5edee98e4281a4a34f8fc39721a62b60d6e1b5"
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
