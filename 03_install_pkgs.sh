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
if [ "$INSTALL_FLASH_ATTN" = "y" ]; then
    MAX_JOBS=16 pip install flash-attn --no-build-isolation
fi
pip install tf-keras
pip install unsloth
pip install thop tiktoken ipykernel transformers diffusers tqdm timm wandb accelerate ninja packaging tensorboard easydict scikit-learn opencv-python datasets fvcore ptflops s3fs webdataset glances[gpu] matplotlib onnx onnxsim onnxruntime llms_from_scratch tokenizers


echo "All Python packages installed."

if [ "$INSTALL_QUALCOMM_SNPE" = "y" ]; then
    echo "You chose to install Qualcomm SNPE. Run: ./install_snpe.sh"
fi
