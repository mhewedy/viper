sudo hostnamectl set-hostname "$(hostname -I | awk '{print $1}')"

echo "export PS1=\"\[\e[1;35m\]\u\[\033[m\]@\[\e[1;92m\]$(hostname -I | awk '{print $1}')\[\033[m\]:\w \$ \"" >>~/.bashrc

## Fix IP Addr

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CC86BB64
sudo add-apt-repository ppa:rmescandon/yq
sudo apt update
sudo apt install yq -y

sudo yq w -i /etc/netplan/50-cloud-init.yaml network.ethernets.enp0s3.dhcp4 false
sudo yq w -i /etc/netplan/50-cloud-init.yaml network.ethernets.enp0s3.addresses[+] "$(hostname -I | awk '{print $1}')/24"
sudo yq w -i /etc/netplan/50-cloud-init.yaml network.ethernets.enp0s3.gateway4 192.168.1.1
sudo yq w -i /etc/netplan/50-cloud-init.yaml network.ethernets.enp0s3.nameservers.addresses[+] 8.8.8.8
sudo yq w -i /etc/netplan/50-cloud-init.yaml network.ethernets.enp0s3.nameservers.addresses[+] 8.8.4.4

sudo netplan apply
