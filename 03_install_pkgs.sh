#!/bin/bash
set -e

if [ -f env_vars.sh ]; then
    source env_vars.sh
else
    echo "Cannot find env_vars.sh. Run previous steps first."
    exit 1
fi

which python
which pip

pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128
pip install transformers diffusers tqdm timm wandb accelerate ninja packaging tensorboard easydict scikit-learn opencv-python datasets fvcore ptflops s3fs webdataset glances[gpu] matplotlib
pip install onnx onnxsim onnxruntime

if [ "$INSTALL_FLASH_ATTN" = "y" ]; then
    pip install flash-attn --no-build-isolation
fi

echo "All Python packages installed."

if [ "$INSTALL_QUALCOMM_SNPE" = "y" ]; then
    echo "You chose to install Qualcomm SNPE. Run: ./install_snpe.sh"
fi
