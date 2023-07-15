#!/bin/bash

# Define variables
TARBALL_NAME="openssl_1.1.1u.tar.gz"
INSTALL_DIR="/opt/ssl"

# Step 1: Extract the tarball
tar -xzf "$TARBALL_NAME"

# Step 2: Copy files to the correct folder structure
cp -R "openssl-${OPENSSL_VERSION}/"* "$INSTALL_DIR/"

# Step 3: Set necessary path variables
export LD_LIBRARY_PATH="$INSTALL_DIR/lib:$LD_LIBRARY_PATH"
export PATH="$INSTALL_DIR/bin:$PATH"

# Step 4: Clean up
rm -rf "openssl-${OPENSSL_VERSION}"
