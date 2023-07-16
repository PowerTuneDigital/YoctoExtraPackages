#!/bin/bash

# Define variables
OPENSSL_VERSION="1.1.1u"
TARBALL_NAME="openssl_1.1.1u.tar.gz"
INSTALL_DIR="/usr/local/ssl"

# Step 1: Extract the tarball
tar -xzf "$TARBALL_NAME"

# Step 2: Copy files to the correct folder structure
cp -R "openssl-${OPENSSL_VERSION}/"* "$INSTALL_DIR/"

# Step 3: Set necessary path variables if not already present in ~/.bashrc
BASHRC="/home/root/.bashrc"

if ! grep -q "export PATH=\"$INSTALL_DIR/bin:\$PATH\"" "$BASHRC"; then
  echo "export PATH=\"$INSTALL_DIR/bin:\$PATH\"" >> "$BASHRC"
fi

if ! grep -q "export LD_LIBRARY_PATH=\"$INSTALL_DIR/lib:\$LD_LIBRARY_PATH\"" "$BASHRC"; then
  echo "export LD_LIBRARY_PATH=\"$INSTALL_DIR/lib:\$LD_LIBRARY_PATH\"" >> "$BASHRC"
fi

# Step 4: Source the ~/.bashrc file to apply changes immediately
source "$BASHRC"

# Step 5: Clean up
rm -rf "openssl-${OPENSSL_VERSION}"

