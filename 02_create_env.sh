#!/bin/bash
set -e

if [ -f env_vars.sh ]; then
    source env_vars.sh
else
    echo "Cannot find env_vars.sh. Run 01_setup_system.sh first."
    exit 1
fi

if ! command -v mamba &> /dev/null; then
    echo "Mamba not found. Ensure Miniforge is installed and PATH set."
    exit 1
fi

if [ "$INSTALL_QUALCOMM_SNPE" = "y" ]; then
    PY_VER="3.10"
else
    PY_VER="3.12"
fi

mamba create -y -n "$ENV_NAME" python=$PY_VER
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate "$ENV_NAME"

echo "Activated conda environment: $ENV_NAME"
echo "You can now run: ./03_install_pkgs.sh"
