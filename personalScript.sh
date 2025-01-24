# My personal packages and customization will be installed now
pacman -S --noconfirm - < pkglist.txt

# Install dotfiles
rm "$HOME/.bashrc"
cp config/bashrc.txt "$HOME/.bashrc"
mkdir "$HOME/.config"
cp alacritty.toml "$HOME/.config/alacritty.toml"

# Install yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay

# Install XFCE Theme
tar -xvf config/Dracula.tar.xz
cp -r config/Dracula /usr/share/themes
xfconf-query -c xsettings -p /Net/ThemeName -s "Dracula"
xfconf-query -c xfwm4 -p /general/theme -s "Dracula"
xfconf-query -c xsettings -p /Net/IconThemeName -s "Dracula"
xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "Dracula"


# Enabling my personal startup script
mkdir -p "$HOME/.config/systemd/user"
cp config/startup.service "$HOME/.config/systemd/user/startup.service"
systemctl --user enable startup.service

cp config/startupservice.sh /usr/local/sbin/startupservice.sh
chmod +x /usr/local/sbin/startup.service.sh

cp config/updatePeriodically.sh "$HOME/.config/systemd/user/updatePeriodically.sh"
cp config/weeklySystemUpdate.sh "$HOME/.config/systemd/user/weeklySystemUpdate.sh"

systemctl --user start startup.service

