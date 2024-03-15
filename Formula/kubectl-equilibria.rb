# frozen_string_literal: true

require_relative "../lib/registry_download"

class KubectlEquilibria < Formula
  desc "Kubectl plugin for interacting with ACE Equilibria"
  homepage "https://git.act3-ace.com/ace/equilibria"
  version "0.9.10"

  depends_on "kubernetes-cli"

  # Generated by https://git.act3-ace.com/ace/homebrew-ace-tools/-/blob/master/bin/formulize.sh
  on_macos do
    if Hardware::CPU.intel?
      url "reg.git.act3-ace.com/ace/equilibria/releases/kubectl-equilibria@sha256:d874b4655d4ae6f73eac3372d39d9676e62a3badc03d03f2fa23d64acd3e48a9",
          using: BlobDownloadStrategy
      sha256 "d874b4655d4ae6f73eac3372d39d9676e62a3badc03d03f2fa23d64acd3e48a9"
    end
    if Hardware::CPU.arm?
      url "reg.git.act3-ace.com/ace/equilibria/releases/kubectl-equilibria@sha256:cd3df1f10136b8ab530cb051cbc388531054b1560914a1599df885d12195a846",
          using: BlobDownloadStrategy
      sha256 "cd3df1f10136b8ab530cb051cbc388531054b1560914a1599df885d12195a846"
    end
  end

  # Generated by https://git.act3-ace.com/ace/homebrew-ace-tools/-/blob/master/bin/formulize.sh
  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "reg.git.act3-ace.com/ace/equilibria/releases/kubectl-equilibria@sha256:d79bcd4370b2ccb88c2581f9fd0be18d7a06e4d72c39c442131361ccae68939c",
          using: BlobDownloadStrategy
      sha256 "d79bcd4370b2ccb88c2581f9fd0be18d7a06e4d72c39c442131361ccae68939c"
    end
    if Hardware::CPU.intel?
      url "reg.git.act3-ace.com/ace/equilibria/releases/kubectl-equilibria@sha256:83befd40e4b9105cfa1642f3f80971ccaa1cd7222544d07caa1632e7dd4429c2",
          using: BlobDownloadStrategy
      sha256 "83befd40e4b9105cfa1642f3f80971ccaa1cd7222544d07caa1632e7dd4429c2"
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
