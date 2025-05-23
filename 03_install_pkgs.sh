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

if [ "$INSTALL_QUALCOMM_SNPE" = "y" ]; then
    DOWNLOAD_URL="https://softwarecenter.qualcomm.com/api/download/software/qualcomm_neural_processing_sdk/v$SNPE_VERSION.zip"
    aria2c "$DOWNLOAD_URL"
    unzip -q "v$SNPE_VERSION.zip"

    # Move to standardized location if desired
    SNPE_ROOT="/home/ubuntu/qairt/$SNPE_VERSION"
    mkdir -p /home/ubuntu/qairt
    mv "$SNPE_VERSION" "$SNPE_ROOT"

    # Add environment variables to ~/.bashrc only if not already set
    grep -qxF "export SNPE_ROOT=$SNPE_ROOT" ~/.bashrc || echo "export SNPE_ROOT=$SNPE_ROOT" >> ~/.bashrc

    # Note: TENSORFLOW_HOME path is example for 'snpe' environment. Adjust if needed.
    TF_HOME="/home/ubuntu/miniforge3/envs/snpe/lib/python3.12/site-packages/tensorflow/core"
    grep -qxF "export TENSORFLOW_HOME=$TF_HOME" ~/.bashrc || echo "export TENSORFLOW_HOME=$TF_HOME" >> ~/.bashrc

    grep -qxF 'export PYTHONPATH=$SNPE_ROOT/lib/python:$PYTHONPATH' ~/.bashrc || echo 'export PYTHONPATH=$SNPE_ROOT/lib/python:$PYTHONPATH' >> ~/.bashrc
    grep -qxF "export LD_LIBRARY_PATH=$SNPE_ROOT/lib/x86_64-linux-clang:\$LD_LIBRARY_PATH" ~/.bashrc || echo "export LD_LIBRARY_PATH=$SNPE_ROOT/lib/x86_64-linux-clang:\$LD_LIBRARY_PATH" >> ~/.bashrc
fi

echo "All Python packages installed."
if [ "$INSTALL_QUALCOMM_SNPE" = "y" ]; then
    echo "Qualcomm SNPE SDK downloaded, extracted, and environment setup updated."
    echo "Please restart your shell or source ~/.bashrc for SNPE environment variables."
fi
