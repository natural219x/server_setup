#!/bin/bash
set -e

# Check for env_vars.sh
if [ -f env_vars.sh ]; then
    source env_vars.sh
else
    echo "Cannot find env_vars.sh. Run 01_setup_system.sh first."
    exit 1
fi

# Check for mamba
if ! command -v mamba &> /dev/null; then
    echo "Mamba not found. Ensure Miniforge is installed and PATH set."
    exit 1
fi

# Create conda environment
# Decide Python version based on SNPE install
if [ "$INSTALL_QUALCOMM_SNPE" = "y" ]; then
    PY_VER="3.10"
else
    PY_VER="3.12"
fi

mamba create -n "$ENV_NAME" python=$PY_VER -y
# Setup conda for activation & activate environment
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate "$ENV_NAME"

echo "Activated conda environment: $ENV_NAME"
echo "You can now run: ./03_install_pkgs.sh"
