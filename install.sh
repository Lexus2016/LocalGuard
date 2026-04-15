#!/bin/sh
# LocalGuard installer — https://github.com/Lexus2016/LocalGuard
# Usage: curl -fsSL https://raw.githubusercontent.com/Lexus2016/LocalGuard/main/install.sh | sh
set -e

REPO="Lexus2016/LocalGuard"
BINARY="llm-security-proxy"
DATA_DIR="${HOME}/.llm-proxy"

# --- Detect OS and architecture ---
OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
    Darwin)  OS_TARGET="apple-darwin" ;;
    Linux)   OS_TARGET="unknown-linux-gnu" ;;
    MINGW*|MSYS*|CYGWIN*)
        echo "On Windows, use install.ps1 instead:"
        echo "  irm https://raw.githubusercontent.com/Lexus2016/LocalGuard/main/install.ps1 | iex"
        exit 1
        ;;
    *)
        echo "Unsupported OS: $OS"
        exit 1
        ;;
esac

case "$ARCH" in
    x86_64|amd64)  ARCH_TARGET="x86_64" ;;
    arm64|aarch64) ARCH_TARGET="aarch64" ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

TARGET="${ARCH_TARGET}-${OS_TARGET}"

# --- Find latest release ---
echo "Detecting latest version..."
LATEST=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')

if [ -z "$LATEST" ]; then
    echo "Failed to detect latest version. Check https://github.com/${REPO}/releases"
    exit 1
fi

echo "Latest version: v${LATEST}"

# --- Download ---
ASSET="${BINARY}-v${LATEST}-${TARGET}.tar.gz"
URL="https://github.com/${REPO}/releases/download/v${LATEST}/${ASSET}"

echo "Downloading ${ASSET}..."
TMPDIR=$(mktemp -d)
curl -fSL "$URL" -o "${TMPDIR}/${ASSET}"

# --- Extract ---
echo "Extracting..."
tar xzf "${TMPDIR}/${ASSET}" -C "${TMPDIR}"

# --- Install binary ---
INSTALL_DIR="/usr/local/bin"

if [ -w "$INSTALL_DIR" ]; then
    mv "${TMPDIR}/${BINARY}" "${INSTALL_DIR}/${BINARY}"
    echo "Binary installed to ${INSTALL_DIR}/${BINARY}"
elif command -v sudo >/dev/null 2>&1; then
    echo "Installing binary to ${INSTALL_DIR} (requires sudo)..."
    sudo mv "${TMPDIR}/${BINARY}" "${INSTALL_DIR}/${BINARY}"
    echo "Binary installed to ${INSTALL_DIR}/${BINARY}"
else
    INSTALL_DIR="${HOME}/.local/bin"
    mkdir -p "$INSTALL_DIR"
    mv "${TMPDIR}/${BINARY}" "${INSTALL_DIR}/${BINARY}"
    echo "Binary installed to ${INSTALL_DIR}/${BINARY}"
    case ":$PATH:" in
        *":${INSTALL_DIR}:"*) ;;
        *)
            echo ""
            echo "Add to your PATH:"
            echo "  export PATH=\"${INSTALL_DIR}:\$PATH\""
            ;;
    esac
fi

chmod +x "${INSTALL_DIR}/${BINARY}"

# --- Install NER models ---
MODELS_DIR="${DATA_DIR}/models"
mkdir -p "$MODELS_DIR"

if [ -d "${TMPDIR}/models" ]; then
    echo "Installing NER models to ${MODELS_DIR}..."
    cp -f "${TMPDIR}/models/"* "${MODELS_DIR}/"
    echo "Models installed: $(ls "${MODELS_DIR}" | tr '\n' ' ')"
else
    echo "Note: No models/ directory in archive (regex-only scanning available)."
fi

# --- Cleanup ---
rm -rf "$TMPDIR"

echo ""
echo "LocalGuard v${LATEST} installed successfully!"
echo ""
echo "Next steps:"
echo "  1. Run setup: ${BINARY} setup"
echo "  2. Purchase:  https://llm-proxy.gumroad.com"
echo "  3. Activate:  ${BINARY} activate"
echo "  4. Start:     ${BINARY} start"
