#!/bin/bash
set -euo pipefail

SSH_DIR="/root/.ssh"
KEY_PATH="${SSH_DIR}/id_rsa"

# Ensure SSH directory exists
mkdir -p "${SSH_DIR}"

# Check if SSH keys already exist
if [[ -f "${KEY_PATH}" && -f "${KEY_PATH}.pub" ]]; then
    echo "✓ SSH keys already exist at ${KEY_PATH}"
else
    echo "⚙ Generating SSH key pair..."
    ssh-keygen -t rsa -b 4096 -f "${KEY_PATH}" -N "" -C "root@$(hostname)"
    echo "✓ SSH keys generated successfully"
fi

# Set proper permissions
chmod 700 "${SSH_DIR}"
chmod 600 "${KEY_PATH}"
chmod 644 "${KEY_PATH}.pub"
echo "✓ Permissions configured"

# Display public key
echo ""
echo "Public Key:"
cat "${KEY_PATH}.pub"