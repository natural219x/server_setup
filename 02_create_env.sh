#!/bin/bash
set -e

if [ -f env_vars.sh ]; then
    source env_vars.sh
else
    echo "Cannot find env_vars.sh. Run 01_setup_system.sh first."
    exit 1
fi

export PATH=~/miniforge3/bin:$PATH

if ! command -v mamba &> /dev/null; then
    echo "Mamba not found. Ensure Miniforge is installed and PATH set."
    exit 1
fi

mamba create -n "$ENV_NAME" python=3.10 -y

echo "Activate your environment: conda activate $ENV_NAME"
echo "After activating, run: ./03_install_pkgs.sh"
