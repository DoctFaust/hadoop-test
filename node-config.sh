sudo wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo && \
sudo wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo && \
sudo yum clean all -y && sudo yum makecache -y && \
sudo yum update -y && \
sudo yum install -y vim net-tools bash-completion rsync openssh-server initscripts
