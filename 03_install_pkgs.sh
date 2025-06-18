#!/bin/bash
set -e

[ -f env_vars.sh ] || { echo "Run previous steps first."; exit 1; }
source env_vars.sh

which python && which pip

pip install \
  torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128 \
  transformers diffusers tqdm timm wandb accelerate ninja packaging tensorboard \
  easydict scikit-learn opencv-python datasets fvcore ptflops s3fs webdataset \
  glances[gpu] matplotlib onnx onnxsim onnxruntime

if [ "$INSTALL_FLASH_ATTN" = "y" ]; then
  pip install flash-attn --no-build-isolation
fi

echo "Python packages installed."
if [ "$INSTALL_QUALCOMM_SNPE" != "y" ]; then
  echo "To install Qualcomm SNPE, run ./04_install_snpe.sh"
fi
