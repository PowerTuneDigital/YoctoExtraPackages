#!/bin/bash

# Define variables
INSTALL_DIR="/usr/local/lib"
TARBALL_URL="https://github.com/PowerTuneDigital/YoctoExtraPackages/raw/main/compiled_perl_openssl.tar.gz"
TARBALL_NAME="compiled_perl_openssl.tar.gz"
TMP_DIR="$(mktemp -d)"

# Step 1: Download the tarball from the GitHub repo
wget "$TARBALL_URL" -O "$TMP_DIR/$TARBALL_NAME"

# Step 2: Extract the tarball
tar -xzf "$TMP_DIR/$TARBALL_NAME" -C "$TMP_DIR"

# Step 3: Check if the extracted Perl and OpenSSL directories exist
if [ -d "$TMP_DIR/perl" ] && [ -d "$TMP_DIR/openssl" ]; then
    # Copy files to the correct folders
    cp -r "$TMP_DIR/perl" "$INSTALL_DIR"
    cp -r "$TMP_DIR/openssl" "$INSTALL_DIR"

    # Step 4: Register it with the system permanently (Add to PATH and LD_LIBRARY_PATH)
    echo "export PATH=\"$INSTALL_DIR/perl/bin:\$PATH\"" >> /etc/profile
    echo "export LD_LIBRARY_PATH=\"$INSTALL_DIR/openssl/lib:\$LD_LIBRARY_PATH\"" >> /etc/profile

    # Optional: Make the changes effective immediately (reload the profile)
    source /etc/profile

    echo "Perl and OpenSSL installation completed!"
else
    echo "Error: The directories 'perl' and/or 'openssl' do not exist in the tarball. Please make sure the tarball contains the correct directories."
fi

# Clean up the temporary directory
rm -rf "$TMP_DIR"
