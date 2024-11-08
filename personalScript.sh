# My personal packages and customization will be installed now
pacman -S --noconfirm - < pkglist.txt

# Install dotfiles
rm ~/.bashrc
mv bashrc.txt ~/.bashrc
mkdir ~/.config
mv alacritty.toml ~/.config/alacritty.toml

# Install yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay

# Install XFCE Theme
tar -xvf Dracula.tar.xz
cp -r Dracula /usr/share/themes
xfconf-query -c xsettings -p /Net/ThemeName -s "Dracula"
xfconf-query -c xfwm4 -p /general/theme -s "Dracula"
xfconf-query -c xsettings -p /Net/IconThemeName -s "Dracula"
xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "Dracula"


# Enabling my personal startup script
mkdir -p ~/.config/systemd/user
cp startup.service ~/.config/systemd/user/startup.service
systemctl --user enable startup.service

cp startupservice.sh /usr/local/sbin/startupservice.sh
chmod +x /usr/local/sbin/startup.service.sh

systemctl --user start startup.service

