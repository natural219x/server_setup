#!/bin/bash
set -e

if [ -f env_vars.sh ]; then
    source env_vars.sh
else
    echo "Cannot find env_vars.sh. Run previous steps first."
    exit 1
fi

# Activate environment
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate "$ENV_NAME"

NO_CUDA_MSG="# Install ^^^ only if CUDA GPU present or skip torch install"
PYTHON_BIN=$(which python)
PIP_BIN=$(which pip)
echo "Using Python: $PYTHON_BIN"
echo "Using pip: $PIP_BIN"

if [ "$INSTALL_TPU_SUPPORT" = "y" ]; then
    # Install CPU torch & XLA
    pip install torch torchvision torchaudio torch_xla[tpu] --extra-index-url https://storage.googleapis.com/tpu-pytorch/xla-release # Don't use CUDA wheels
    pip uninstall -y tensorflow || true
    pip install tensorflow-cpu
    echo "Installed torch/torch_xla for TPU (no CUDA)."
else
    # Default: CUDA wheels
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128
fi

if [ "$INSTALL_FLASH_ATTN" = "y" ]; then
    MAX_JOBS=16 pip install flash-attn --no-build-isolation
fi

pip install tf-keras

if [ "$INSTALL_UNSLOTH" = "y" ]; then
    pip install unsloth[cu118]
else
    pip install unsloth
fi

pip install thop tiktoken ipykernel transformers diffusers tqdm timm wandb accelerate ninja packaging tensorboard easydict scikit-learn opencv-python datasets fvcore ptflops s3fs webdataset glances[gpu] matplotlib onnx onnxsim onnxruntime llms_from_scratch tokenizers

echo "All Python packages installed."

if [ "$INSTALL_QUALCOMM_SNPE" = "y" ]; then
    echo "You chose to install Qualcomm SNPE. Run: ./install_snpe.sh"
fi
