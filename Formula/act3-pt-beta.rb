# frozen_string_literal: true

require_relative "../lib/registry_download"

class Act3PtBeta < Formula
  desc "ACT3 Project Tool Beta - ACT3's project generator, updater, and automator"
  homepage "https://git.act3-ace.com/devsecops/act3-pt/-/tree/beta"
  version "2.0.0-beta.14"

  depends_on "glab"
  depends_on "typst"

  # Generated by https://git.act3-ace.com/ace/homebrew-ace-tools/-/blob/master/bin/formulize.sh
  on_macos do
    if Hardware::CPU.intel?
      url "reg.git.act3-ace.com/devsecops/act3-pt/releases/act3-pt@sha256:8223156e28083451273fcb7221a547833056a7a24841356d652f1ebbe3917e9c",
          using: BlobDownloadStrategy
      sha256 "8223156e28083451273fcb7221a547833056a7a24841356d652f1ebbe3917e9c"
    end
    if Hardware::CPU.arm?
      url "reg.git.act3-ace.com/devsecops/act3-pt/releases/act3-pt@sha256:85eb05bfbfcbc9b171fab0a03cbdfd6f10e009e80f8785494750031ce032b8fc",
          using: BlobDownloadStrategy
      sha256 "85eb05bfbfcbc9b171fab0a03cbdfd6f10e009e80f8785494750031ce032b8fc"
    end
  end

  # Generated by https://git.act3-ace.com/ace/homebrew-ace-tools/-/blob/master/bin/formulize.sh
  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "reg.git.act3-ace.com/devsecops/act3-pt/releases/act3-pt@sha256:f2e119d8d2be32bfdedfd1c4639d629e9241d0252a83f887dd9c8a28b3878439",
          using: BlobDownloadStrategy
      sha256 "f2e119d8d2be32bfdedfd1c4639d629e9241d0252a83f887dd9c8a28b3878439"
    end
    if Hardware::CPU.intel?
      url "reg.git.act3-ace.com/devsecops/act3-pt/releases/act3-pt@sha256:e8a42955a5be359826bb31121ee190b3fe1e67bad9ba4b4776298b41a11de5db",
          using: BlobDownloadStrategy
      sha256 "e8a42955a5be359826bb31121ee190b3fe1e67bad9ba4b4776298b41a11de5db"
    end
  end

  conflicts_with "act3-pt", because: "act3-pt and act3-pt-beta install conflicting executables"

  def install
    bin.install "act3-pt"
    generate_completions_from_executable(bin/"act3-pt", "completion")

    # Generate manpages
    mkdir "man" do
      system bin/"act3-pt", "gendocs", "man", "."
      man1.install Dir["*.1"]
      man5.install Dir["*.5"]
    end

    # Generate JSON Schema definitions
    # Use pkgetc here so path doesn't change over version numbers
    # Cannot use symlink for this because VS Code cannot follow symlinks for schema files
    mkdir pkgetc do
      system bin/"act3-pt", "genschema", "."
    end
  end

  def caveats
    <<~EOS
      Add the following to VS Code's settings.json file to enable YAML file validation:
        "yaml.schemas": {
          "file://#{pkgetc}/project.act3-ace.io.schema.json": [
            ".project.yaml",
            ".act3-pt.yaml",
            ".blueprint.yaml",
            ".act3-template.yaml",
            ".blueprintcatalog.yaml",
            "catalog.yaml"
          ],
          "file://#{pkgetc}/pt.act3-ace.io.schema.json": [
            "act3-pt-config.yaml",
            "act3/pt/config.yaml"
          ]
        }

      Check out the quick start guide to get started with act3-pt:
        act3-pt info quick-start-guide
    EOS
  end

  test do
    system "#{bin}/act3-pt", "version"
  end
end
