clear

sudo timedatectl set-timezone Etc/GMT-5

# Ensure dependencies are met

sudo pacman -Sy --noconfirm arch-install-scripts
clear



# Disk Partitioning

if [ -d /sys/firmware/efi ]; then
    echo ""
    echo "Detected UEFI system."
    echo -e "\033[1;36mPlease create the following partitions:\033[0m"
    echo ""
    echo "===================================="
    echo "For UEFI:"
    echo "1. EFI system partition (1 GiB)"
    echo "2. Root partition"
    echo "===================================="
echo -e "\033[1;31mPlease make /dev/sdX1 the EFI system partition (1 GiB) and /dev/sdX2 the root partition\033[0m"
else
    echo ""
    echo "Detected BIOS system."
    echo ""
    echo -e "\033[1;36mPlease create the following partitions:\033[0m"
    echo "===================================="
    echo "For BIOS:"
    echo "1. Root partition"
    echo "===================================="
fi
echo ""

read -p "Do you want to use cfdisk to set up partitions?(Y/n) " response
response=${response,,}
if [[ -z "$response" || "$response" == "y" ]]; then
    cfdisk
elif [[ "$response" == "n" ]]; then
    echo "Skipping partition setup."
else
    echo "Invalid input. Script aborting."
    exit 1
fi



# Creating filesystem

echo -e "\033[1;36mWhat will be your main drive for Arch?\033[0m"
echo -e "\033[38;5;214m(Drive names like /dev/sda are ok but do NOT type partition names like /dev/sda1)\033[0m"

fdisk -l | grep /dev | awk '{print "\033[1;37m" $0 "\033[0m"}'
read -p "Enter your choice: " main_drive
echo -e "You have selected: \033[1;36m$main_drive\033[0m"

echo -e "\e[31mNow formatting partitions in 5 seconds (Press Ctrl + C to abort script)\e[0m"

sleep 5
if [ -d /sys/firmware/efi ]; then
    # For UEFI system
    mkfs.fat -F32 "${main_drive}1"
    mkfs.ext4 "${main_drive}2"
    mount "${main_drive}2" /mnt
    mkdir -p /mnt/boot
    mount "${main_drive}1" /mnt/boot
else
    # For BIOS system
    mkfs.ext4 "${main_drive}1"
    mount "${main_drive}1" /mnt
fi


# GRUB Installation

pacstrap -K /mnt base linux linux-firmware dhcpcd
genfstab /mnt >> /mnt/etc/fstab

if [ -d /sys/firmware/efi ]; then
    arch-chroot /mnt bash -c "pacman -Sy --noconfirm grub efibootmgr; grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ArchLinux; grub-mkconfig -o /boot/grub/grub.cfg"
else
    arch-chroot /mnt bash -c "pacman -Sy --noconfirm grub; grub-install --target=i386-pc $main_drive; grub-mkconfig -o /boot/grub/grub.cfg"
fi


# Necessary packages
arch-chroot /mnt bash -c "pacamn -S --noconfirm base-devel dosfstools lvm2 mtools nano neovim networkmanager openssh os-prober sudo linux linux-headers linux-lts linux-lts-headers linux-firmware; mkinitcpio -p linux; mkinitcpio -p linux-lts; sed -i '/^#.*en_US.UTF-8/s/^#//' /etc/locale.gen; locale-gen"


# Hostname setup and Account Creation

echo -e "\e[1;37mWhat is your desired hostname for the system?\e[0m"
read hostname
echo -e "\e[1;37mPlease set the root password for your system now\e[0m"
arch-chroot /mnt bash -c "echo "$hostname" > /etc/hostname; sudo passwd"

echo -e "\e[1;37mPlease enter your desired username:\e[0m"
read username
arch-chroot /mnt bash -c "useradd -m -G wheel '$username' && passwd '$username'; echo \"$username ALL=(ALL:ALL) ALL\" >> /etc/sudoers"


# A few tweaks
arch-chroot /mnt bash -c "sed -i '/\[multilib\]/{N;s/^#//;}' /etc/pacman.conf"

unmount -a

echo -e "\e[1;32mScript has finished! :D\e[0m"
echo -e "\033[1;36mPlease chroot into drive or reboot to view changes\033[0m"
