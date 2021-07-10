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

Available drivers are listed under:

`ubuntu-drivers devices`

As of Jul-09-2021, the latest (stable) driver was nvidia-driver-465 and a [CUDA compatibility table can be found here](https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/index.html)

`sudo apt-get install nvidia-driver-465 nvidia-settings`

Install Miniconda

`wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh`

Install nvcc and nvprof

`conda install -c conda-forge cudatoolkit-dev` 

Note that you may need to reboot the server in order to resolve any CUDA driver/library version mismatches. If you are able to execute:

`nvidia-smi`

Then, you should be good to go. Otherwise, try rebooting the server (requires sudo).

Install RAPIDS suite

`conda install -c nvidia -c rapidsai -c numba -c conda-forge -c pytorch -c defaults cudf=0.8 cuml=0.8 cugraph=0.8 python=3.7 cudatoolkit=10.0`

If you encounter any error messages that complain about, say, `libcublas.so` not being found that you may need to add the following environment variable to your `.bashrc`:

`export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64/`

The CUDA libraries are added by root to each `/usr/local/cuda` but, as a standard user, you'll need to explicitly define where the libraries can be found

# Identifying the Current Nvidia Driver Version

`nvidia-smi`

# Installing Updates

First, you'll want to download and install any security updates:

`sudo apt update`

`sudo apt upgrade`

Then purge the old driver(s)

`sudo apt purge nvidia-driver-430`

Next, you can retrieve a list of the latest Nvidia drivers with:

`apt search nvidia-driver | grep nvidia-driver`

And install the latest one:

`sudo apt install nvidia-driver-465`

Finally, clean up unnecessary packages with:

`sudo apt autoremove`

# Mounting the HDD

[Follow these steps](https://medium.com/@sh.tsang/partitioning-formatting-and-mounting-a-hard-drive-in-linux-ubuntu-18-04-324b7634d1e0) to mount the HDD from /dev/sda
