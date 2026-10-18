#!/usr/bin/env bash
# Install Pop Shell from source, picking the git branch matching the GNOME version
set -euo pipefail

REPO_URL="https://github.com/pop-os/shell.git"
BUILD_DIR="${HOME}/.cache/pop-shell-build"

# --- Check that GNOME Shell is installed -------------------------------------
if ! command -v gnome-shell >/dev/null 2>&1; then
    echo "gnome-shell not found: Pop Shell only works with GNOME. Exiting."
    exit 1
fi

# --- Detect the GNOME version ------------------------------------------------
# Output looks like "GNOME Shell 42.9" or "GNOME Shell 3.36.9"
GNOME_FULL=$(gnome-shell --version | awk '{print $3}')
GNOME_MAJOR=${GNOME_FULL%%.*}

# Before GNOME 40, the minor number identifies the release (3.36, 3.38)
if [ "$GNOME_MAJOR" = "3" ]; then
    GNOME_KEY=$(echo "$GNOME_FULL" | cut -d. -f1,2)
else
    GNOME_KEY="$GNOME_MAJOR"
fi

echo "Detected GNOME Shell version: ${GNOME_FULL}"

# --- Map the GNOME version to a Pop Shell branch ------------------------------
case "$GNOME_KEY" in
    3.36) BRANCH="master_focal"   ;;
    3.38) BRANCH="master_groovy"  ;;
    40)   BRANCH="master_hirsute" ;;
    41)   BRANCH="master_impish"  ;;
    42)   BRANCH="master_jammy"   ;;
    43)   BRANCH="master_kinetic" ;;
    44)   BRANCH="master_lunar"   ;;
    45)   BRANCH="master_mantic"  ;;
    46)   BRANCH="master_noble"   ;;
    *)    BRANCH="master"         ;;  # newer than the known releases
esac

# --- Make sure the branch really exists, otherwise fall back to master -------
if ! git ls-remote --exit-code --heads "$REPO_URL" "$BRANCH" >/dev/null 2>&1; then
    echo "Branch ${BRANCH} not found upstream, falling back to master."
    BRANCH="master"
fi

echo "Using branch: ${BRANCH}"

# --- Install build dependencies -----------------------------------------------
echo "Installing build dependencies (sudo required)..."
sudo apt update
sudo apt install -y git build-essential node-typescript gnome-shell-extensions

# --- Clone (or update) and build ----------------------------------------------
if [ -d "${BUILD_DIR}/.git" ]; then
    echo "Updating existing clone..."
    git -C "$BUILD_DIR" fetch origin "$BRANCH"
    git -C "$BUILD_DIR" checkout "$BRANCH"
    git -C "$BUILD_DIR" reset --hard "origin/${BRANCH}"
else
    rm -rf "$BUILD_DIR"
    git clone --branch "$BRANCH" "$REPO_URL" "$BUILD_DIR"
fi

cd "$BUILD_DIR"
make local-install

# --- Enable the extension -------------------------------------------------------
# This only works from inside a running GNOME session
if [ "${XDG_CURRENT_DESKTOP:-}" != "" ] && pgrep -x gnome-shell >/dev/null; then
    gnome-extensions enable pop-shell@system76.com || \
        echo "Could not enable it yet: log out and back in, then run:"
        echo "  gnome-extensions enable pop-shell@system76.com"
else
    echo "Not in a GNOME session. Log in to GNOME, then run:"
    echo "  gnome-extensions enable pop-shell@system76.com"
fi

echo "Done. Log out and back in if the extension does not appear."
