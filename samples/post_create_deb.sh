sudo apt install -y openssh-server
useradd -m -s /bin/bash vm_user
echo "vm_user ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
wget https://raw.githubusercontent.com/mhewedy/vm/master/keys/vm_rsa.pub -O - >>~/.ssh/authorized_keys
