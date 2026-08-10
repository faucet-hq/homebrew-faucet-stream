class FaucetCli < Formula
  desc "Config-driven CLI runner for faucet-stream pipelines (YAML / JSON, Meltano-style)"
  homepage "https://faucet-hq.github.io/faucet-stream/"
  version "1.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/faucet-hq/faucet-stream/releases/download/faucet-cli-v1.8.0/faucet-cli-aarch64-apple-darwin.tar.xz"
      sha256 "063d47c1416a4f4c89c7c66f013db50aab075fa4ed7622689e42dded67931e98"
    end
    if Hardware::CPU.intel?
      url "https://github.com/faucet-hq/faucet-stream/releases/download/faucet-cli-v1.8.0/faucet-cli-x86_64-apple-darwin.tar.xz"
      sha256 "1c4cdf7a32690a29b3abbea24662e5a5d7987326d93a9d6a51758a99da4b0a33"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/faucet-hq/faucet-stream/releases/download/faucet-cli-v1.8.0/faucet-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "af346bce94e8d85f20e53be2d2e90b9dd4726c539c38855c9993c23a82e3c2ea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/faucet-hq/faucet-stream/releases/download/faucet-cli-v1.8.0/faucet-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "90555c73d02034cb345f30dc022492bdd6f28e2e02160afab6fbc0a623557035"
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
    bin.install "faucet" if OS.mac? && Hardware::CPU.arm?
    bin.install "faucet" if OS.mac? && Hardware::CPU.intel?
    bin.install "faucet" if OS.linux? && Hardware::CPU.arm?
    bin.install "faucet" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
