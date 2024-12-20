clear

sudo timedatectl set-timezone Etc/GMT-5


read -p "Do you want to set up partitions first? (y/N): " response

response=${response,,}
if [[ -z "$response" ]]; then
    response="n"
fi

if [[ "$response" == "y" ]]; then
    cfdisk
elif [[ "$response" == "n" ]]; then
    echo "Skipping partition setup."
else
    echo "Invalid input. Script aborting."
    exit 1
fi

echo -e "\033[1;36mWhat will be your main drive for Arch? (e.g. /dev/sda, /dev/sdb1)\033[0m"
fdisk -l | grep /dev | awk '{print "\033[1;37m" $0 "\033[0m"}'
read -p "Enter your choice: " main_drive
echo -e "You have selected: \033[1;36m$main_drive\033[0m"

echo "Now formatting $main_drive in 5 seconds (Press Ctrl + C to abort script)"
sleep 5
mkfs.ext4 "${main_drive}"
mount $main_drive /mnt

pacstrap -K /mnt base linux linux-firmware
genfstab /mnt > /mnt/etc/fstab
arch-chroot /mnt bash -c "pacman -Sy grub; grub-install $main_drive; grub-mkconfig -o /boot/grub/grub.cfg"

echo -e "\033[1;36m Please chroot into drive or reboot to view changes\033[0m"

