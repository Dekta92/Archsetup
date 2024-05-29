alias neofetch='fastfetch'
alias desktop='startxfce4'

# Making sure Wi-Fi adapter is on
rfkill unblock wlan0
iwctl device wlan0 set-property Powered on

clear
fastfetch
