#!/bin/bash

# Define the GitHub repository URL
REPO_URL="https://github.com/PowerTuneDigital/YoctoExtraPackages.git"

# Define the paths for Perl and OpenSSL
PERL_INSTALL_PATH="/usr/local/lib/perl5/5.38.0"
OPENSSL_INSTALL_PATH="/usr/local/lib"
OPENSSL_BIN_PATH="/usr/local/bin"

# Create a temporary directory to hold downloaded files
TMP_DIR="$(mktemp -d)"

# Function to check if a command is available
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if 'git' command is available
if ! command_exists git; then
    echo "Error: 'git' command not found. Please install git before running this script."
    exit 1
fi

# Clone the GitHub repository to the temporary directory
git clone "$REPO_URL" "$TMP_DIR"

# Navigate to the extracted directory containing the tarball
cd "$TMP_DIR/YoctoExtraPackages"

# Extract the tarball
tar -xzf compiled_perl_openssl.tar.gz

# Copy the compiled Perl and OpenSSL files to the correct paths
cp -r perl "$PERL_INSTALL_PATH"
cp -r openssl "$OPENSSL_INSTALL_PATH"
cp openssl/bin/openssl "$OPENSSL_BIN_PATH"

# Set environment variables for Perl and OpenSSL
export PATH="$OPENSSL_BIN_PATH:$PATH"
export LD_LIBRARY_PATH="$OPENSSL_INSTALL_PATH/lib:$LD_LIBRARY_PATH"

# Register the versions of Perl and OpenSSL
echo "export PATH=\"$OPENSSL_BIN_PATH:\$PATH\"" >> /etc/profile.d/yocto_extra_packages.sh
echo "export LD_LIBRARY_PATH=\"$OPENSSL_INSTALL_PATH/lib:\$LD_LIBRARY_PATH\"" >> /etc/profile.d/yocto_extra_packages.sh

# Reload the profile to apply the changes
source /etc/profile

echo "Installation completed successfully."

