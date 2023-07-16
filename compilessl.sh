#!/bin/bash

# Define variables
OPENSSL_VERSION="1.1.1u"
INSTALL_DIR="/usr/local/ssl"
TARBALL_NAME="openssl_${OPENSSL_VERSION}.tar.gz"

# Step 1: Download OpenSSL source
wget "https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz" -O "$TARBALL_NAME"

# Step 2: Extract the source
tar -xzf "$TARBALL_NAME"

# Step 3: Configure and compile OpenSSL
cd "openssl-${OPENSSL_VERSION}"

# Enable Soft Float ABI for ARM architectures without an FPU
#export CC="gcc -mfloat-abi=softfp -march=armv7-a"
./Configure --prefix="$INSTALL_DIR" --openssldir="$INSTALL_DIR" shared zlib linux-armv4 no-asm no-threads
#./config --prefix="$INSTALL_DIR" --openssldir="$INSTALL_DIR" shared zlib

make
make install

# Step 4: Create the tarball
cd ..
tar -czf "$TARBALL_NAME" "Yoctoopenssl-${OPENSSL_VERSION}"

# Step 5: Clean up
rm -rf "openssl-${OPENSSL_VERSION}"
