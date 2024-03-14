# frozen_string_literal: true

require_relative "../lib/registry_download"

class Act3Pt < Formula
  desc "ACT3 Project Tool - ACT3's project management toolbox"
  homepage "https://git.act3-ace.com/devsecops/act3-pt"
  version "2.1.3"

  depends_on "glab"
  depends_on "typst"

  # Generated by https://git.act3-ace.com/ace/homebrew-ace-tools/-/blob/master/bin/formulize.sh
  on_macos do
    if Hardware::CPU.intel?
      url "reg.git.act3-ace.com/devsecops/act3-pt/releases/act3-pt@sha256:ec03c8a9b1d9dcb42eb2f518e57c51e237aa9efe898acee3a904fcfbad55aa60",
          using: BlobDownloadStrategy
      sha256 "ec03c8a9b1d9dcb42eb2f518e57c51e237aa9efe898acee3a904fcfbad55aa60"
    end
    if Hardware::CPU.arm?
      url "reg.git.act3-ace.com/devsecops/act3-pt/releases/act3-pt@sha256:6f16ecd56a7f993a0284fbb2f407c9eb7e74d2a010f9dc5b5c32c0744bf0d48d",
          using: BlobDownloadStrategy
      sha256 "6f16ecd56a7f993a0284fbb2f407c9eb7e74d2a010f9dc5b5c32c0744bf0d48d"
    end
  end

  # Generated by https://git.act3-ace.com/ace/homebrew-ace-tools/-/blob/master/bin/formulize.sh
  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "reg.git.act3-ace.com/devsecops/act3-pt/releases/act3-pt@sha256:576f04decbdeb006ec581c46e0daeca3415ce6605f26bd413f4e2382bd633af7",
          using: BlobDownloadStrategy
      sha256 "576f04decbdeb006ec581c46e0daeca3415ce6605f26bd413f4e2382bd633af7"
    end
    if Hardware::CPU.intel?
      url "reg.git.act3-ace.com/devsecops/act3-pt/releases/act3-pt@sha256:bf660ff108c49b760541702d0f79bc08cdfd27d86523cc509764f546a422991d",
          using: BlobDownloadStrategy
      sha256 "bf660ff108c49b760541702d0f79bc08cdfd27d86523cc509764f546a422991d"
    end
  end

  conflicts_with "act3-pt-beta", because: "act3-pt and act3-pt-beta install conflicting executables"

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
