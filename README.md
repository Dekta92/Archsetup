# Archsetup
This project consists of two scripts that can be used to 
* Install a minimal version of Arch Linux on your system
* Install my personal config

## Installation
### Minimal Install
```bash
git clone https://github.com/Dekta92/Archsetup
cd Archsetup
chmod +x baseInstallation.sh
./baseInstallation.sh
```
### Personal Config
Boot into the system and run
```bash
git clone https://github.com/Dekta92/Archsetup
cd Archsetup
chmod +x personalScript.sh
sudo ./personalScript.sh
```
or if you want to do it directly via chroot
```bash
mount /drive/and/partition/name /mnt
mv personalScript.sh /mnt/personalScript.sh
arch-chroot /mnt bash -c "chmod +x personalScript.sh; ./personalScript.sh"
```
