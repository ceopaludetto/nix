#!/bin/sh
set -euo pipefail

# Unlock bitwarden
echo "Unlocking Bitwarden Vault..."
export BW_SESSION=$(bw unlock --raw)

# Sync vault
echo "Syncing Bitwarden Vault..."
bw sync

# Getting password
echo "Generating secrets..."
CONTENT=$(opsops render --input .sops.generate.yaml)

if [ "${1:-}" == "--print" ] && [ "$1" == "--print" ]; then
	echo "$CONTENT"
fi

# Generating SOPS file
echo "Generating SOPS file..."
echo "$CONTENT" | sops --encrypt --input-type yaml --output-type yaml /dev/stdin > assets/secrets.yaml

# Lock bitwarden
echo "Locking Bitwarden Vault..."
bw lock

echo "Printing new nix configuration..."
echo "$(opsops snippet sops-nix --input .sops.generate.yaml)"
