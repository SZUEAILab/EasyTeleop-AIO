#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Export EasyTeleop images to offline tarballs (amd64/arm64).

Usage:
  ./export-tars.sh [-r IMAGE_REPO] [-t TAG] [-o OUT_DIR] [-a amd64|arm64|both] [--skip-build] [--skip-pull]

Defaults:
  IMAGE_REPO=easyteleop
  TAG=latest
  OUT_DIR=dist
  ARCH=both

Notes:
  - Produces 2 tar files by default: one for amd64, one for arm64.
  - Each tar contains 6 images:
      ${IMAGE_REPO}/backend:${TAG}-${arch}
      ${IMAGE_REPO}/node:${TAG}-${arch}
      ${IMAGE_REPO}/frontend:${TAG}-${arch}
      ${IMAGE_REPO}/hdf5:${TAG}-${arch}
      nginx:1.25-alpine-${arch}
      emqx/emqx:5.3.1-${arch}
EOF
}

IMAGE_REPO="easyteleop"
TAG="latest"
OUT_DIR="dist"
ARCH="both"
SKIP_BUILD="0"
SKIP_PULL="0"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -r|--image-repo) IMAGE_REPO="$2"; shift 2 ;;
    -t|--tag) TAG="$2"; shift 2 ;;
    -o|--out-dir) OUT_DIR="$2"; shift 2 ;;
    -a|--arch) ARCH="$2"; shift 2 ;;
    --skip-build) SKIP_BUILD="1"; shift ;;
    --skip-pull) SKIP_PULL="1"; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1"; usage; exit 2 ;;
  esac
done

if ! command -v docker >/dev/null 2>&1; then
  echo "docker not found in PATH"
  exit 1
fi

if ! docker buildx version >/dev/null 2>&1; then
  echo "docker buildx not available (need Docker Buildx)"
  exit 1
fi

mkdir -p "$OUT_DIR"

sanitize_filename() {
  echo "$1" | sed -E 's#[^A-Za-z0-9_.-]+#_#g'
}

export_one_arch() {
  local arch="$1"

  if [[ "$SKIP_BUILD" != "1" ]]; then
    IMAGE_REPO="$IMAGE_REPO" TAG="$TAG" docker buildx bake -f docker-bake.hcl "tar_${arch}" --load
  fi

  if [[ "$SKIP_PULL" != "1" ]]; then
    docker pull --platform "linux/${arch}" "nginx:1.25-alpine"
    docker tag "nginx:1.25-alpine" "nginx:1.25-alpine-${arch}"

    docker pull --platform "linux/${arch}" "emqx/emqx:5.3.1"
    docker tag "emqx/emqx:5.3.1" "emqx/emqx:5.3.1-${arch}"

  fi

  local repo_slug
  repo_slug="$(sanitize_filename "$IMAGE_REPO")"
  local out_tar="${OUT_DIR}/${repo_slug}-${TAG}-${arch}.tar"

  docker save -o "$out_tar" \
    "${IMAGE_REPO}/backend:${TAG}-${arch}" \
    "${IMAGE_REPO}/node:${TAG}-${arch}" \
    "${IMAGE_REPO}/frontend:${TAG}-${arch}" \
    "${IMAGE_REPO}/hdf5:${TAG}-${arch}" \
    "nginx:1.25-alpine-${arch}" \
    "emqx/emqx:5.3.1-${arch}"

  echo "Wrote: $out_tar"
}

case "$ARCH" in
  amd64) export_one_arch "amd64" ;;
  arm64) export_one_arch "arm64" ;;
  both)
    export_one_arch "amd64"
    export_one_arch "arm64"
    ;;
  *)
    echo "Invalid arch: $ARCH (expected amd64|arm64|both)"
    exit 2
    ;;
esac
