#!/bin/bash
set -e

[ -f env_vars.sh ] || { echo "Run 01_setup_system.sh first."; exit 1; }
source env_vars.sh

command -v mamba &>/dev/null || { echo "Install Miniforge/mamba first."; exit 1; }

mamba create -n "$ENV_NAME" python=3.10 -y
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate "$ENV_NAME"

echo "Activated $ENV_NAME. Next: ./03_install_pkgs.sh"
