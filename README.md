# Getting Started with Ubuntu 18.04

[Download Ubuntu 18.04](http://releases.ubuntu.com/18.04/)

1. Attach all peripheral devices directly to the server and not through the KVM switch. Also, ensure that you are connected to the internet is possible.
2. Turn on the machine
3. Turn on the machine (seriously)
4. Wait for the server start screen to appear and get to the startup/boot menu
5. Select `Boot Menu`
6. Select the `UEFI - <name of USB Stick>` to load the `GNU GRUB` 
7. Select `Install Ubuntu` and you should eventually see the Ubuntu load screen
8. On the Ubuntu `Welcome` screen, choose `English` and `Continue`
9. On the `Keyboard layout` screen, choose `English (US)`
10. On the `Updates and other software` screen, choose `Minimal installtion` and check the `Install third-party software for graphics and Wi-Fi hardware, Flash, MP3 and other media` box and hit `Continue`. Note that the "Download updates while installing Ubuntu` box will be greyed out if you are not connected to a network with external internet access
11. On the Ubuntu `Installation type` screen, select `Erase disk and install Ubuntu` option and hit `Continue`
12. On the Ubuntu `Erase disk and install Ubuntu` screen, select the drive that you'd like to install on and hit `Install Now`
13. On the pop up `Write the changes to disk`, hit `Continue`
14. On the `Where are you?` screen, hit `Continue`
15. On the `Who are you?` screen, choose your username and password and hit `Continue`
16. Installation should commence and complete. Hit `Restart Now`

# Setting Things Up

`sudo ./setup.sh`

This script will prompt you for your LDAP server name and credentials that will allow you to connect and verify AD credentials. Additionally, it will install all of the necessary software and setup PAM (pluggable authentication modules) for SSH. Users will first authenticate (behind the scenes) against LDAP if they already have a home directory on the server. If the user does not already have a home directory then they will not be able to authenticate (see Add Users below). Note that when LDAP authentication fails then PAM will continue along with its regularly scheduled authentication process.

# Add Users 

This will add a user, setup their home directory, and initialize their bash environment

`sudo useradd -m <username> -s /bin/bash`

# Delete Users

`sudo userdel <username>`

`sudo rm -rf /home/<username>`

# Setup NVIDIA 1080Ti Graphics Card
`sudo sed -i 's/quiet splash/quiet splash pci=nomsi/' /etc/default/grub`

`sudo update-grub`

`sudo apt-get install nvidia-driver-390 nvidia-settings`

`conda install -c nvidia -c rapidsai -c numba -c conda-forge -c pytorch -c defaults cudf=0.8 cuml=0.8 cugraph=0.8 python=3.7 cudatoolkit=10.0`
