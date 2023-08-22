ARG DENO_VERSION="v1.36.2"

DENO_VERSION="${DENO_VERSION:-$(curl -q -LSsf https://api.github.com/repos/denoland/deno/releases/latest | grep '"name"' | sed 's|.*: ||g;s|"||g;s|,||g' | sort -Vr | head -n1 | grep '^' || echo "v1.36.2")}"
if [ "$(uname -m)" = "amd64" ] || [ "$(uname -m)" = "x86_64" ]; then
  ARCH="x86_64"
  CHANNEL="github.com/denoland/deno"
  URL="https://github.com/denoland/deno/releases/download/$DENO_VERSION/deno-$ARCH-unknown-linux-gnu.zip"
  LATEST="$(curl -q -LSsf https://api.github.com/repos/denoland/deno/releases/latest | grep 'browser_download_url' | grep 'linux' | grep "$ARCH" | sed 's|.*: ||g;s|"||g;s|,||g' | sort -Vr | head -n1)"
  BIN_FILE="/usr/bin/deno"
  TMP_DIR="/tmp/deno-$ARCH"
  TMP_FILE="/tmp/deno-$ARCH.zip"
elif [ "$(uname -m)" = "arm64" ] || [ "$(uname -m)" = "aarch64" ]; then
  ARCH="arm64"
  CHANNEL="github.com/LukeChannings/deno-arm64"
  URL="https://github.com/LukeChannings/deno-arm64/releases/download/$DENO_VERSION/deno-linux-$ARCH.zip"
  LATEST="$(curl -q -LSsf https://api.github.com/repos/LukeChannings/deno-arm64/releases/latest | grep 'browser_download_url' | grep 'linux' | grep "$ARCH" | sed 's|.*: ||g;s|"||g;s|,||g' | sort -Vr | head -n1)"
  BIN_FILE="/usr/bin/deno"
  TMP_DIR="/tmp/deno-$ARCH"
  TMP_FILE="/tmp/deno-$ARCH.zip"
else
  echo "Unsupported architecture"
  exit 1
fi
echo "grabbing deno $DENO_VERSION from $CHANNEL for $ARCH"
if curl -q -LSsf -o "$TMP_FILE" "$URL" && [ -f "$TMP_FILE" ]; then
  mkdir -p "$TMP_DIR" && cd "$TMP_DIR" || exit 10
  unzip -q "$TMP_FILE"
  if [ -f "$TMP_DIR/deno" ]; then
    cp -Rf "$TMP_DIR/deno" "$BIN_FILE" && chmod -Rf 755 "$BIN_FILE" || exitCode=10
    [ -f "$BIN_FILE" ] && $BIN_FILE upgrade && exitCode=0 || exitCode=10
  else
    echo "Failed to extract deno from $TMP_FILE"
    exitCode=10
  fi
else
  echo "Failed to download deno from $URL"
  exitCode=2
fi
rm -Rf "$TMP_FILE" "$TMP_DIR"
