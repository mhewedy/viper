sudo apt install -y openssh-server
sudo useradd -m -s /bin/bash vm_user
echo "vm_user ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
sudo mkdir -p /home/vm_user/.ssh &&
  wget https://raw.githubusercontent.com/mhewedy/vm/master/keys/vm_rsa.pub -O - | sudo tee -a /home/vm_user/.ssh/authorized_keys &&
  sudo chmod 400 /home/vm_user/.ssh/authorized_keys
