# frozen_string_literal: true

require_relative "../lib/registry_download"

class KubectlEquilibria < Formula
  desc "Kubectl plugin for interacting with ACE Equilibria"
  homepage "https://git.act3-ace.com/ace/equilibria"
  version "0.9.7"

  depends_on "kubernetes-cli"

  # Generated by https://git.act3-ace.com/ace/homebrew-ace-tools/-/blob/master/bin/formulize.sh
  on_macos do
    if Hardware::CPU.intel?
      url "reg.git.act3-ace.com/ace/equilibria/releases/kubectl-equilibria@sha256:47de9a5ec247499213a8d3db0ead0d2f693132e21b5a10490f1dffcf2c9049c2",
          using: BlobDownloadStrategy
      sha256 "47de9a5ec247499213a8d3db0ead0d2f693132e21b5a10490f1dffcf2c9049c2"
    end
    if Hardware::CPU.arm?
      url "reg.git.act3-ace.com/ace/equilibria/releases/kubectl-equilibria@sha256:1dd2d2f38a70fa4dbf01b5f4b860ebf2a3c766fded8a8c6f4cd48c556c86b0aa",
          using: BlobDownloadStrategy
      sha256 "1dd2d2f38a70fa4dbf01b5f4b860ebf2a3c766fded8a8c6f4cd48c556c86b0aa"
    end
  end

  # Generated by https://git.act3-ace.com/ace/homebrew-ace-tools/-/blob/master/bin/formulize.sh
  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "reg.git.act3-ace.com/ace/equilibria/releases/kubectl-equilibria@sha256:0b2875dde26c5024898bd73c23ad1c750ad4906cb51357f927993ac6e4b4c726",
          using: BlobDownloadStrategy
      sha256 "0b2875dde26c5024898bd73c23ad1c750ad4906cb51357f927993ac6e4b4c726"
    end
    if Hardware::CPU.intel?
      url "reg.git.act3-ace.com/ace/equilibria/releases/kubectl-equilibria@sha256:86ee0d5bfd3eeb2fd66561d57eb8a52c5f6144fd4a1858a1902e71d555f97a11",
          using: BlobDownloadStrategy
      sha256 "86ee0d5bfd3eeb2fd66561d57eb8a52c5f6144fd4a1858a1902e71d555f97a11"
    end
  end

  def install
    bin.install "kubectl-equilibria"
    generate_completions_from_executable(bin/"kubectl-equilibria", "completion")

    # # Generate manpages
    # mkdir "man" do
    #   system bin/"kubectl-equilibria", "gendocs", "man", "."
    #   man1.install Dir["*.1"]
    #   # man5.install Dir["*.5"]
    # end
  end

  test do
    system "#{bin}/kubectl-equilibria", "version"
  end
end
