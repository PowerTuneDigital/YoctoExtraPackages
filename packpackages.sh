#!/bin/bash

# Function to compare version numbers
version_gt() {
    test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1";
}

# Check for Perl version
PERL_VERSION=$(perl -e 'print substr($^V, 1)')

# Check for OpenSSL version
OPENSSL_VERSION=$(openssl version -a | awk '/OpenSSL/ {print $2}' | sed 's/u$//') # Remove 'u' from version string

echo "Detected Perl version: $PERL_VERSION"
echo "Detected OpenSSL version: $OPENSSL_VERSION"

# Define the Perl and OpenSSL directories based on version
PERL_LIB="/usr/local/lib/perl5/5.38.0"
OPENSSL_LIB="/usr/local/lib"

# Check if the Perl and OpenSSL directories exist
if [ -d "$PERL_LIB" ] && [ -d "$OPENSSL_LIB" ] && command -v openssl >/dev/null; then
    # Correct paths for Perl 5.38.0 and OpenSSL 1.1.1 (without 'u')
    OPENSSL_EXECUTABLE=$(command -v openssl)
else
    # If the installed versions don't match the expected versions or directories don't exist, show an error message
    echo "Error: The installed versions of Perl or OpenSSL do not match the expected versions (Perl: 5.38.0, OpenSSL: 1.1.1u), or the necessary directories are missing. Make sure you have compiled the correct versions first and that the directories exist."
    exit 1
fi

# Create a temporary directory to hold compiled files
TMP_DIR="$(mktemp -d)"

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
