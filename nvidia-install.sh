#!/bin/bash


# Pastikan script dijalankan sebagai root
if [[ $EUID -ne 0 ]]; then
   echo "Script ini harus dijalankan dengan sudo atau sebagai root." 
   exit 1
fi


echo "Mengunduh dan menginstal keyring CUDA..."
wget -q https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
dpkg -i cuda-keyring_1.1-1_all.deb
apt-get update


echo "Menginstal driver NVIDIA versi 550..."
apt install -y cuda-drivers-550


echo "Menginstal CUDA Toolkit versi 12.4..."
apt-get -y install cuda-toolkit-12-4


echo "Menambahkan PATH CUDA ke file /etc/profile.d/cuda.sh..."
cat <<EOF > /etc/profile.d/cuda.sh
export PATH=\$PATH:/usr/local/cuda/bin
EOF


echo "Menambahkan PATH CUDA ke file ~/.bashrc..."
echo "export PATH=\$PATH:/usr/local/cuda/bin" >> ~/.bashrc


echo "Memuat ulang profile..."
source /etc/profile.d/cuda.sh
source ~/.bashrc


echo "Memeriksa instalasi NVCC..."
nvcc --version || { echo "Gagal menjalankan nvcc. Pastikan CUDA Toolkit terinstal dengan benar."; exit 1; }


echo "Memeriksa instalasi NVIDIA-SMI..."
if ! nvidia-smi; then
    echo
    echo "Gagal menjalankan nvidia-smi. Periksa instalasi driver NVIDIA."
    echo
    echo "CATATAN:"
    echo "- Jika driver NVIDIA belum terdeteksi, silakan reboot perangkat Anda dan coba lagi."
    exit 1
fi


echo "Proses instalasi selesai."
