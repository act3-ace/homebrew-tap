#!/usr/bin/env bash
set -e

# Argument is a tag in an OCI registry, tag should be pointing to an image index
# ./formulize.sh reg.git.act3-ace.com/ace/homebrew-ace-tools/formula/act3-pt:v1.50.11
INDEX_TAG=$1

# REGISTRY=reg.git.act3-ace.com/ace/homebrew-ace-tools/formula/act3-pt
# TAG=v1.50.11
REGISTRY=${INDEX_TAG%:*} # Remove everything after last colon (short suffix)
TAG=${INDEX_TAG##*:}     # Remove everything before last colon (long prefix)

# Download the image index once
image_index=$(crane manifest "${REGISTRY}:${TAG}")

function blob_digest() {
  os=$1
  arch=$2
  image_digest=$(echo "${image_index}" | os=${os} arch=${arch} yq '.manifests[] | select(.platform.os == env(os) and .platform.architecture == env(arch)) | .digest')
  [ "${image_digest}" == "null" ] && return 1
  blob_digest=$(crane manifest "${REGISTRY}@${image_digest}" | yq '.layers[0].digest')
  [ "${blob_digest}" == "null" ] && return 1
  echo "${blob_digest}"
}

darwin_amd64=$(blob_digest darwin amd64)
darwin_arm64=$(blob_digest darwin arm64)
linux_amd64=$(blob_digest linux amd64)
linux_arm64=$(blob_digest linux arm64)

cat <<EOF
  # Generated by https://git.act3-ace.com/ace/homebrew-ace-tools/-/blob/master/bin/formulize.sh
  on_macos do
    if Hardware::CPU.intel?
      url "${REGISTRY}@${darwin_amd64}",
          using: BlobDownloadStrategy
      sha256 "${darwin_amd64#*:}"
    end
    if Hardware::CPU.arm?
      url "${REGISTRY}@${darwin_arm64}",
          using: BlobDownloadStrategy
      sha256 "${darwin_arm64#*:}"
    end
  end

  # Generated by https://git.act3-ace.com/ace/homebrew-ace-tools/-/blob/master/bin/formulize.sh
  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "${REGISTRY}@${linux_arm64}",
          using: BlobDownloadStrategy
      sha256 "${linux_arm64#*:}"
    end
    if Hardware::CPU.intel?
      url "${REGISTRY}@${linux_amd64}",
          using: BlobDownloadStrategy
      sha256 "${linux_amd64#*:}"
    end
  end
EOF
