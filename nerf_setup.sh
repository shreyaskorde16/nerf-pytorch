#!/bin/bash
set -euo pipefail  # Exit on error, unset variables, and pipeline failures

# Update and install system dependencies
echo "Updating system and installing dependencies..."
echo "=============================================="
echo -e "\nUpdating package lists and installing required packages..."
sudo apt-get update
sudo apt-get install -y wget git build-essential libgl1 libglib2.0-0

# Install Miniconda if not already installed
if [ ! -d "$HOME/miniconda" ]; then
  echo -e "\nInstalling Miniconda..."
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
  bash ~/miniconda.sh -b -p "$HOME/miniconda"
  rm -f ~/miniconda.sh
fi

# Add Miniconda to PATH if not already added
if [[ ":$PATH:" != *":$HOME/miniconda/bin:"* ]]; then
  export PATH="$HOME/miniconda/bin:$PATH"
fi

# Initialize conda if not already initialized
if ! grep -q "conda initialize" ~/.bashrc; then
  conda init bash
  source ~/.bashrc
fi

# Initialize conda for bash
source ~/miniconda/etc/profile.d/conda.sh

# Accept Anaconda ToS for required channels
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

# Create conda environment if it doesn't exist
if ! conda env list | grep -q "nerf"; then
  echo -e "\nCreating conda environment 'nerf'..."
  conda create -n nerf python=3.7 -y
fi

# Activate the environment
conda activate nerf

# Download and install CUDA 11.3
echo -e "\nDownloading CUDA 11.3..."

echo -e "\nInstalling CUDA 11.3..."
#sudo sh cuda_11.3.1_465.19.01_linux.run --silent --toolkit --override
echo -e "\nCUDA Installation Completed"

# Set LD_LIBRARY_PATH for CUDA and WSL
export LD_LIBRARY_PATH=/usr/local/cuda-11.3/lib64:/usr/lib/wsl/lib:$LD_LIBRARY_PATH

# Install PyTorch and dependencies
echo -e "\nInstalling PyTorch and dependencies..."
pip install torch==1.11.0+cu113 torchvision==0.12.0+cu113 torchaudio==0.11.0 --extra-index-url https://download.pytorch.org/whl/cu113

# Install requirements (assuming requirements.txt is in the current directory)
pip install -r nerf-pytorch/requirements.txt

# Verify CUDA installation
echo -e "\nVerifying CUDA installation..."
nvcc --version || echo "CUDA installation failed or nvcc not found."

# Verify PyTorch CUDA support
python -c "import torch; print('PyTorch version:', torch.__version__); print('CUDA available:', torch.cuda.is_available())"
