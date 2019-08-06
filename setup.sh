#!/bin/bash

if [ $(id -u) != "0" ]; then
    echo "Please execute this script with sudo privileges"
    exit 1
fi

DIR=`pwd`

# Gather LDAP Server Information
echo "Please provide an LDAP server to Connect to (e.g., ldap://ldap.example.com):"
read LDAP_SERVER
echo "Please provide an LDAP service account name (e.g., zServiceAccount@example.com):"
read LDAP_USR
read -s -p "Please provide the LDAP service account password:" LDAP_PWD
echo

# Install Linux Environment
sudo apt-get install -y vim ssh
echo 'alias vi="vim"' >> ~/.bashrc
echo 'alias rm="rm -i"' >> ~/.bashrc

# Install Miniconda
wget --no-check-certificate https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash ./Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda3
eval "$($HOME/miniconda3/bin/conda shell.bash hook)"
conda config --set ssl_verify no
if ! grep -q "$HOME/miniconda3/bin" $HOME/.bashrc; then
    echo "export PATH=$HOME/miniconda3/bin:\$PATH" >> $HOME/.bashrc
fi

# Create pam.sh Script
cat > $DIR/pam.sh << EOF
#!/bin/sh

read PAM_PWD
$HOME/miniconda3/bin/python $DIR/pam.py $LDAP_USR $LDAP_PWD $LDAP_SERVER $PAM_USER $PAM_PWD >> /tmp/log 2>&1
EOF
chmod u+x pam.sh

#LDAP Authentication
conda install -y ldap3
sudo echo -e "auth sufficient pam_exec.so expose_authtok $DIR/pam.sh\n\n$(cat /etc/pam.d/sshd)" > /etc/pam.d/sshd
