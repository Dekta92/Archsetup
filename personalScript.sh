# My personal packages and customization will be installed now
pacman -S - < pkglist.txt
rm ~/.bashrc
mv bashrc.txt ~/.bashrc
mv alacritty.toml ~/.config/alacritty.toml
unzip Catpuccin-Mocha-B.zip
mv Catpuccin-Mocha-B ~/.config/gtk-4.0 

