set -e

CURRENT_NODE=$1
NODES_STRING=$2
HOST_PUBLIC_KEY=$3
HOME_DIR=/opt/hadoop

sudo wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo >/dev/null 2>&1
sudo wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo >/dev/null 2>&1
sudo yum clean all -y >/dev/null 2>&1
sudo yum makecache >/dev/null 2>&1
sudo yum update -y >/dev/null 2>&1
sudo yum install -y -q vim net-tools bash-completion initscripts rsync openssh-server openssh-clients sshpass >/dev/null 2>&1

sudo mkdir -p /var/run/sshd "$HOME_DIR/.ssh/authorized_keys"
sudo echo "hadoop:123456" | sudo chpasswd
sudo sed -i 's/#PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config

sudo ssh-keygen -A >/dev/null 2>&1
sudo /usr/sbin/sshd

if [ ! -f "$HOME_DIR/.ssh/id_rsa" ]; then
    sudo -u hadoop ssh-keygen -t rsa -N "" -f "$HOME_DIR/.ssh/id_rsa" >/dev/null 2>&1
fi

IFS='.' read -ra NODES <<< "$NODES_STRING"
for target_node in "${NODES[@]}"; do
    if [ "$target_node" != "$CURRENT_NODE" ]; then
        sudo -u hadoop sshpass -p "123456" ssh-copy-id -o StrictHostKeyChecking=no -i "$HOME_DIR/.ssh/id_rsa" hadoop@$target_node >/dev/null 2>&1 || true
    fi
done

if [ -f "$HOST_PUBLIC_KEY" ]; then
    sudo cat "$HOST_PUBLIC_KEY" >> "$HOME_DIR/.ssh/authorized_keys"
fi

sudo chown -R hadoop:hadoop "$HOME_DIR/.ssh"
sudo chmod 700 "$HOME_DIR/.ssh"
sudo chmod 600 "$HOME_DIR/.ssh/authorized_keys"
