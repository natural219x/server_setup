#!/bin/bash
set -e

[ -f env_vars.sh ] || { echo "Run 01_setup_system.sh first."; exit 1; }
source env_vars.sh

if [ "$INSTALL_QUALCOMM_SNPE" != "y" ]; then
  echo "SNPE installation skipped."; exit 0
fi

DOWNLOAD_URL="https://softwarecenter.qualcomm.com/api/download/software/qualcomm_neural_processing_sdk/v$SNPE_VERSION.zip"
aria2c -x16 -s16 "$DOWNLOAD_URL"

unzip -q "v$SNPE_VERSION.zip"

SNPE_ROOT="$HOME/qairt/$SNPE_VERSION"
mkdir -p "$(dirname "$SNPE_ROOT")"
mv "$SNPE_VERSION" "$SNPE_ROOT"

# Append to ~/.bashrc if missing
grep -qxF "export SNPE_ROOT=$SNPE_ROOT" ~/.bashrc || \
  echo "export SNPE_ROOT=$SNPE_ROOT" >> ~/.bashrc

TF_HOME="$HOME/miniforge3/envs/$ENV_NAME/lib/python3.12/site-packages/tensorflow/core"
grep -qxF "export TENSORFLOW_HOME=$TF_HOME" ~/.bashrc || \
  echo "export TENSORFLOW_HOME=$TF_HOME" >> ~/.bashrc

grep -qxF 'export PYTHONPATH=$SNPE_ROOT/lib/python:$PYTHONPATH' ~/.bashrc || \
  echo 'export PYTHONPATH=$SNPE_ROOT/lib/python:$PYTHONPATH' >> ~/.bashrc

grep -qxF "export LD_LIBRARY_PATH=$SNPE_ROOT/lib/x86_64-linux-clang:\$LD_LIBRARY_PATH" ~/.bashrc || \
  echo "export LD_LIBRARY_PATH=$SNPE_ROOT/lib/x86_64-linux-clang:\$LD_LIBRARY_PATH" >> ~/.bashrc

echo "SNPE SDK installed to $SNPE_ROOT."
echo "Please restart your shell or run: source ~/.bashrc"
