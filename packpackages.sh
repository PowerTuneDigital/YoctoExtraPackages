#!/bin/bash

# Find the Perl executable path
PERL_EXECUTABLE=$(which perl)

# Find the Perl library path
PERL_LIB=$(perl -e 'use Config; print $Config{installsitelib}')

# Find the OpenSSL library path
OPENSSL_LIB=$(openssl version -d | awk -F'"' '{print $2}')

# Find the OpenSSL executable path
OPENSSL_EXECUTABLE=$(which openssl)

# Create a temporary directory to hold compiled files
TMP_DIR="$(mktemp -d)"

# Check if the Perl and OpenSSL directories exist
if [ -x "$PERL_EXECUTABLE" ] && [ -d "$PERL_LIB" ] && [ -d "$OPENSSL_LIB" ] && [ -x "$OPENSSL_EXECUTABLE" ]; then
    # Copy compiled Perl files
    cp -r "$PERL_LIB" "$TMP_DIR/perl"

    # Copy compiled OpenSSL files
    cp -r "$OPENSSL_LIB" "$TMP_DIR/openssl"
    cp "$OPENSSL_EXECUTABLE" "$TMP_DIR/openssl/bin/"

    # Create a tarball containing the compiled Perl & OpenSSL files
    TARBALL_NAME="compiled_perl_openssl.tar.gz"
    tar -czf "$TARBALL_NAME" -C "$TMP_DIR" .

    # Move the tarball to the desired location
    mv "$TARBALL_NAME" /home/pi/YoctoExtraPackages/test

    # Clean up the temporary directory
    rm -rf "$TMP_DIR"

    echo "Tarball created successfully."
else
    echo "Error: The directories '$PERL_EXECUTABLE', '$PERL_LIB', '$OPENSSL_LIB', and/or '$OPENSSL_EXECUTABLE' do not exist. Make sure you have compiled Perl and OpenSSL first."
fi
