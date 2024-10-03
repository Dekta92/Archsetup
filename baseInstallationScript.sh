sudo timedatectl set-timezone Etc/GMT-5


read -p "Do you want to set up any partitions first? (y/N): " response

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

clear

echo -e "\033[1;37mWhat will be your main drive for Arch? (e.g. /dev/sda, /dev/sdb1)\033[0m"
fdisk -l | grep /dev/sd | awk '{print "\033[1;37m" $0 "\033[0m"}'
read -p "Enter your choice: " main_drive
echo "You have selected: $main_drive"

echo "Now formatting $main_drive in 5 seconds (Press Ctrl + C to abort script)"
sleep 5
mkfs.ext4 "${main_drive}1"

mount $main_drive /mnt
genfstab /mnt > /mnt/etc/fstab
arch-chroot /mnt bash -c 'pacman -Sy grub; grub-install $main_drive; grub-mkconfig -o /boot/grub/grub.cfg'
reboot
