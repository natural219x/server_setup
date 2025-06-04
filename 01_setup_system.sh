#!/bin/bash
set -e

# Configurable SNPE version (no 'v' prefix)
SNPE_VERSION="2.22.6.240515"
MINIFORGE_DIR="$HOME/miniforge3"

sudo apt update
sudo apt install -y aria2 libunwind8

sudo ln -sf /lib/x86_64-linux-gnu/libunwind.so.8 /lib/x86_64-linux-gnu/libunwind.so.1

read -p "Enter the environment name: " ENV_NAME
read -p "Do you want to download and install Miniforge? (y/n): " INSTALL_MINIFORGE
read -p "Do you want to install flash-attn? (y/n): " INSTALL_FLASH_ATTN
read -p "Do you want to install Qualcomm SNPE SDK? (y/n): " INSTALL_QUALCOMM_SNPE

if [ "$INSTALL_MINIFORGE" = "y" ]; then
    if [ -d "$MINIFORGE_DIR" ]; then
        echo "Directory $MINIFORGE_DIR already exists."
        PS3="Choose what to do: "
        select opt in "Remove and reinstall" "Skip installation" "Abort"; do
            case $REPLY in
                1 ) rm -rf "$MINIFORGE_DIR"; break;;
                2 ) INSTALL_MINIFORGE="n"; break;;
                3 ) echo "Aborted."; exit 1;;
                * ) echo "Invalid option";;
            esac
        done
    fi

    if [ "$INSTALL_MINIFORGE" = "y" ]; then
        URL="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
        aria2c -x 16 -s 16 "$URL"
        bash Miniforge3-$(uname)-$(uname -m).sh -b
        # Add Miniforge to PATH in ~/.bashrc if not already present
        if ! grep -q 'miniforge3/bin' ~/.bashrc; then
            echo 'export PATH=~/miniforge3/bin:$PATH' >> ~/.bashrc
        fi
        export PATH=~/miniforge3/bin:$PATH
        conda init bash
    fi
fi

cat > env_vars.sh << EOF
export ENV_NAME="$ENV_NAME"
export INSTALL_FLASH_ATTN="$INSTALL_FLASH_ATTN"
export INSTALL_QUALCOMM_SNPE="$INSTALL_QUALCOMM_SNPE"
export SNPE_VERSION="$SNPE_VERSION"
EOF

echo "Basic system setup complete. Next: run 02_create_env.sh"
