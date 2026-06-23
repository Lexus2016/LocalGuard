#!/bin/sh
# LocalGuard installer — downloads the prebuilt CLI binary from GitHub Releases
# and installs it as `localguard` (with `llm-security-proxy` kept as an alias).
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/Lexus2016/LocalGuard/main/install.sh | sh
#
# Optional environment overrides:
#   LOCALGUARD_VERSION=v0.6.2   # pin a specific release tag (default: latest)
#   LOCALGUARD_BIN_DIR=/path    # install dir (default: /usr/local/bin if writable, else ~/.local/bin)
set -eu

REPO="Lexus2016/LocalGuard"
BIN="llm-security-proxy"
ALIAS="localguard"

# ── pretty output ────────────────────────────────────────────────
info()  { printf '\033[0;34m==>\033[0m %s\n' "$*"; }
ok()    { printf '\033[0;32m✓\033[0m %s\n' "$*"; }
warn()  { printf '\033[0;33mwarning:\033[0m %s\n' "$*" >&2; }
die()   { printf '\033[0;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

# ── prerequisites ────────────────────────────────────────────────
need() { command -v "$1" >/dev/null 2>&1 || die "required tool not found: $1"; }
need uname
need tar
if command -v curl >/dev/null 2>&1; then
  DL="curl -fsSL"
  DL_OUT="curl -fsSL -o"
elif command -v wget >/dev/null 2>&1; then
  DL="wget -qO-"
  DL_OUT="wget -qO"
else
  die "need either curl or wget"
fi

# ── detect OS + arch → release target triple ─────────────────────
os="$(uname -s)"
arch="$(uname -m)"

case "$arch" in
  x86_64|amd64)      arch="x86_64" ;;
  aarch64|arm64)     arch="aarch64" ;;
  *) die "unsupported architecture: $arch" ;;
esac

case "$os" in
  Linux)
    target="${arch}-unknown-linux-gnu"
    ;;
  Darwin)
    if [ "$arch" != "aarch64" ]; then
      die "no prebuilt CLI for macOS Intel. Install via Homebrew instead:
       brew tap lexus2016/tap https://github.com/Lexus2016/homebrew-tap
       brew install localguard
     or build from source: https://github.com/$REPO"
    fi
    target="aarch64-apple-darwin"
    ;;
  *) die "unsupported OS: $os (supported: Linux, macOS arm64)" ;;
esac

# ── resolve version (release tag) ────────────────────────────────
TAG="${LOCALGUARD_VERSION:-}"
if [ -z "$TAG" ]; then
  info "Resolving latest release..."
  TAG="$($DL "https://api.github.com/repos/$REPO/releases/latest" \
        | grep '"tag_name"' \
        | sed -E 's/.*"tag_name"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/' \
        | head -1)"
  [ -n "$TAG" ] || die "could not determine latest release tag (set LOCALGUARD_VERSION=vX.Y.Z)"
fi

asset="${BIN}-${TAG}-${target}.tar.gz"
url="https://github.com/$REPO/releases/download/${TAG}/${asset}"

# ── pick install dir ─────────────────────────────────────────────
if [ -n "${LOCALGUARD_BIN_DIR:-}" ]; then
  BIN_DIR="$LOCALGUARD_BIN_DIR"
elif [ -w /usr/local/bin ] 2>/dev/null; then
  BIN_DIR="/usr/local/bin"
else
  BIN_DIR="$HOME/.local/bin"
fi
mkdir -p "$BIN_DIR" || die "cannot create install dir: $BIN_DIR"
PREFIX="$(dirname "$BIN_DIR")"

info "Installing LocalGuard $TAG ($target) → $BIN_DIR"

# ── download + extract into a temp dir ───────────────────────────
tmp="$(mktemp -d 2>/dev/null || mktemp -d -t localguard)"
trap 'rm -rf "$tmp"' EXIT INT TERM

info "Downloading ${asset}"
$DL_OUT "$tmp/$asset" "$url" || die "download failed: $url"

info "Extracting..."
tar -xzf "$tmp/$asset" -C "$tmp" || die "extraction failed (corrupt archive?)"

# locate the binary inside the archive (root or a subdir)
src="$(find "$tmp" -type f -name "$BIN" 2>/dev/null | head -1)"
[ -n "$src" ] || die "binary '$BIN' not found inside archive"

# ── install binary + alias symlink ───────────────────────────────
chmod +x "$src"
mv -f "$src" "$BIN_DIR/$BIN"
ln -sf "$BIN" "$BIN_DIR/$ALIAS"
ok "Installed $BIN_DIR/$BIN"
ok "Created command '$ALIAS' → $BIN"

# ── optional NER models (advanced detection) ─────────────────────
models_src="$(find "$tmp" -type d -name models 2>/dev/null | head -1)"
if [ -n "$models_src" ]; then
  models_dst="$PREFIX/share/localguard/models"
  mkdir -p "$models_dst"
  cp -R "$models_src/." "$models_dst/" 2>/dev/null || true
  ok "Installed NER models → $models_dst"
  # Mirror the Homebrew formula: expose models at ~/.llm-proxy/models so the
  # daemon finds them when advanced (NER) detection is enabled in the config.
  user_models="$HOME/.llm-proxy/models"
  if [ ! -e "$user_models" ] && [ ! -L "$user_models" ]; then
    mkdir -p "$HOME/.llm-proxy"
    if ln -s "$models_dst" "$user_models" 2>/dev/null; then
      ok "Linked $user_models → $models_dst"
    fi
  fi
else
  info "No NER models in archive — running in regex-only mode (set 'advanced.path' in config to enable NER)."
fi

# ── PATH hint ────────────────────────────────────────────────────
case ":$PATH:" in
  *":$BIN_DIR:"*) : ;;
  *) warn "$BIN_DIR is not in your PATH. Add it, e.g.:
       echo 'export PATH=\"$BIN_DIR:\$PATH\"' >> ~/.profile && . ~/.profile" ;;
esac

printf '\n'
ok "Done. LocalGuard $TAG is installed."
cat <<EOF

  Next steps:
    localguard start                  # start the proxy daemon
    localguard status                 # check it is running
    localguard launch opencode        # run opencode routed through the proxy

  (the legacy name '$BIN' also still works)
EOF
