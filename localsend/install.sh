#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Fetching the latest LocalSend release for Linux (x86_64)..."

# Query the GitHub API to find the download URL for the latest .deb package
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/localsend/localsend/releases/latest | grep "browser_download_url.*linux-x86-64\.deb" | cut -d '"' -f 4)

if [ -z "${DOWNLOAD_URL}" ]; then
    echo "Error: Could not find the download URL. Check your internet connection or the GitHub API status."
    exit 1
fi

echo "Downloading LocalSend from: ${DOWNLOAD_URL}"

# Download the package to the temporary directory
TMP_DEB="/tmp/localsend_latest.deb"
curl -L -o "${TMP_DEB}" "${DOWNLOAD_URL}"

echo "Installing LocalSend..."

# Install the package using dpkg
# We use '|| true' to prevent the script from exiting if dependencies are missing
sudo dpkg -i "${TMP_DEB}" || true

# Fix any missing dependencies that dpkg couldn't resolve
sudo apt-get install -f -y

# Clean up the temporary file
rm -f "${TMP_DEB}"

echo "Creating symlink with name localsend instead of localsend_app"
# Create a symlink from the actual binary to the desired command name
sudo ln -s /usr/bin/localsend_app /usr/local/bin/localsend

echo "LocalSend installation completed successfully."
