sudo apt install -y openssh-server
sudo useradd -m -s /bin/bash viper
echo "viper:viper" | sudo chpasswd
echo "viper ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
sudo mkdir -p /home/viper/.ssh &&
  wget https://raw.githubusercontent.com/mhewedy/viper/master/keys/viper_rsa.pub -O - | sudo tee -a /home/viper/.ssh/authorized_keys &&
  sudo chmod 400 /home/viper/.ssh/authorized_keys && sudo chown viper:viper /home/viper/.ssh/authorized_keys
