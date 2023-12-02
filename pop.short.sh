#!/bin/bash

   ###############################
   # POP!_OS Post-Install Script #
   ############################### v.0.4.231202 # short

 ### missing parts:
 # - import browser bookmarks
 # - set dns 1.1.1.1

# ask for sudo permissions, set screen resolution and variables
sudo clear && xrandr -s 1920x1080 && cd ~
startpackages=$(apt list --installed 2>/dev/null | wc -l)
seconds=0

# quickly install xdotool and toggle auto-tiling on
sudo apt install xdotool -y >/dev/null 2>&1
xdotool key --clearmodifiers 133+52

# change some gsettings and settle on left side
gsettings set org.gnome.desktop.notifications show-banners false
gsettings set org.gnome.desktop.session idle-delay 7200
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 7200
gsettings set org.gnome.shell.extensions.pop-cosmic overlay-key-action WORKSPACES
gsettings set org.gnome.shell.extensions.pop-cosmic show-application-menu false
gsettings set org.gnome.shell.extensions.pop-cosmic show-applications-button false
gsettings set org.gnome.shell.extensions.pop-cosmic show-workspaces-button false
gsettings set org.gnome.shell.extensions.pop-cosmic clock-alignment LEFT
gsettings set org.gnome.desktop.calendar show-weekdate true
gsettings set org.gnome.shell.extensions.appindicator tray-pos left
gsettings set org.gnome.shell.extensions.appindicator icon-size 24
gsettings set org.gnome.desktop.interface enable-animations false
gsettings set org.gnome.desktop.interface text-scaling-factor 1.25
gsettings set org.gnome.desktop.interface clock-format 24h
gsettings set org.gnome.desktop.wm.preferences button-layout "close,minimize,maximize:"

# change hostname and enhance privacy settings
#sudo hostnamectl set-hostname bnc-laptop 
sudo systemctl disable bluetooth
sudo systemctl stop bluetooth
gsettings set org.gnome.desktop.privacy disable-camera true
gsettings set org.gnome.desktop.privacy disable-microphone true
gsettings set org.gnome.desktop.privacy old-files-age 7
gsettings set org.gnome.desktop.privacy recent-files-max-age 7
gsettings set org.gnome.desktop.privacy remove-old-temp-files true
gsettings set org.gnome.desktop.privacy remove-old-trash-files true

# add repos and upgrade packages
sudo add-apt-repository universe -y
sudo add-apt-repository multiverse -y
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y

# install mscorefonts
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
sudo apt install ttf-mscorefonts-installer -y

# install packages
sudo apt install -y \
  ubuntu-restricted-extras \
  gimp \
  vlc \
  rhythmbox \
  transmission \
  steam \
  gnome-tweaks \
  dconf-editor \
  gnome-boxes \
  nautilus-admin \
  gir1.2-gtop-2.0 \
  python3-gpg \
  cpufetch \
  neofetch \
  lm-sensors \
  webp-pixbuf-loader \
  gdebi-core \
  speedtest-cli \
  libnotify-bin \
  gamemode \
  youtube-dl
  
# install brave browser
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser -y

# comment out "127.0.1.1 pop-os.localdomain pop-os" in the /etc/hosts file
# fix battle.net connection error
sudo cp /etc/hosts /etc/hosts.bak
sudo sed -i '/127.0.1.1.*pop-os/ s/^/#/' /etc/hosts

# modify /etc/bluetooth/main.conf file
# fix bluetooth notifications with experimental=true
sudo cp /etc/bluetooth/main.conf /etc/bluetooth/main.conf.bak
sudo sed -i '2i\Experimental=true' /etc/bluetooth/main.conf
sudo systemctl enable bluetooth.service
sudo systemctl restart bluetooth.service

# disable appcenter background service
sudo mv /etc/xdg/autostart/io.elementary.appcenter-daemon.desktop /etc/xdg/autostart/io.elementary.appcenter-daemon.desktop.bak

# add aliases to .bash_aliases file
echo "alias friss='sudo apt update && sudo apt upgrade -y && sudo apt autoremove --purge -y && flatpak update -y && flatpak uninstall --unused -y && flatpak repair --user'" >> ~/.bash_aliases
source ~/.bash_aliases

# create directories
sleep 1
#mkdir -vp \
  .config/autostart \
  .local/share/rhythmbox/plugins \
  .themes \
  .icons \
  Documents/Allati \
  Documents/Books \
  Documents/Scripts \
  Downloads/Applications \
  Downloads/Isos \
  Downloads/Torrents \
  Pictures/Wallpapers \
  Pictures/Icons \
  Pictures/Photos \
  Pictures/Portraits \
  Pictures/Screenshots 

# create bookmarks in nautilus
#echo -e file:///home/$USER/MEGA MEGA\ >> ~/.config/gtk-3.0/bookmarks
#echo -e file:///home/$USER/Documents/Scripts Scripts\ >> ~/.config/gtk-3.0/bookmarks
#echo -e file:///home/$USER/Downloads/Torrents Torrents\ >> ~/.config/gtk-3.0/bookmarks

# download and install MEGA
#wget --show-progress -qO ~/Downloads/Applications/MEGA.deb "https://mega.nz/linux/repo/xUbuntu_22.04/amd64/megasync-xUbuntu_22.04_amd64.deb"
#sudo gdebi ~/Downloads/Applications/MEGA.deb --n
#echo ""
#echo "   Sign in to MEGA! Wait until the synchronizing is done!"
#megasync 2>/dev/null &
#read -rsn1 -p "   Then, press Enter here in the terminal to continue!"

# copy my files from mega
#cp ~/MEGA/POP/scripts/* ~/Documents/Scripts/
#cp ~/MEGA/POP/pictures/icons/* ~/Pictures/Icons/
#cp ~/MEGA/POP/applications/* ~/Downloads/Applications/
#cp ~/MEGA/POP/autostart/* ~/.config/autostart/
#cp ~/MEGA/POP/pictures/wallpapers/* ~/Pictures/Wallpapers/
#cp ~/MEGA/BNC/Videos/live* ~/Videos/Hidamari/
#cp ~/MEGA/BNC/Pictures/* ~/Pictures/
#cp ~/MEGA/BNC/Music/* ~/Music/
#cp ~/MEGA/BNC/Allati/* ~/Documents/Allati/
#cp ~/MEGA/BNC/PDFs/* ~/Documents/Books/
#cp -r ~/MEGA/POP/rhythmbox/* ~/.local/share/rhythmbox/plugins/
#cp -r ~/MEGA/POP/config/* ~/.config/

# change wallpapers
#gsettings set org.gnome.desktop.background picture-uri-dark 'file:///home/'$USER'/Pictures/Wallpapers/space.jpg'
#gsettings set org.gnome.desktop.background picture-uri 'file:///home/'$USER'/Pictures/Wallpapers/space.jpg'

# download and install discord
#wget --show-progress -qO ~/Downloads/Applications/discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
#sudo gdebi ~/Downloads/Applications/discord.deb --n

# download and install freetube nightly build
#latest_release=$(wget -qO- https://github.com/FreeTubeApp/FreeTube-Nightly/releases | grep -oP 'href="/FreeTubeApp/FreeTube-Nightly/releases/tag/v\K[^/"]*' | head -1)
#wget "https://github.com/FreeTubeApp/FreeTube-Nightly/releases/download/v${latest_release}/freetube_${latest_release}_amd64.deb" --show-progress -qO ~/Downloads/Applications/freetube-nightly.deb
#sudo gdebi ~/Downloads/Applications/freetube-nightly.deb --n

# download and install simplenote
#latest_release=$(wget -qO- https://github.com/Automattic/simplenote-electron/releases | grep -oP 'href="/Automattic/simplenote-electron/releases/tag/v\K[^/"]*' | head -1)
#latest_release_no_beta=${latest_release%-*}
#wget "https://github.com/Automattic/simplenote-electron/releases/download/v${latest_release}/Simplenote-linux-${latest_release_no_beta}-amd64.deb" --show-progress -q -O ~/Downloads/Applications/simplenote.deb
#sudo gdebi ~/Downloads/Applications/simplenote.deb --n

# fix simplenote bug with the "--no-sandbox" flag
#sudo sed -i '/^Exec/ s/$/ --no-sandbox/' /usr/share/applications/simplenote.desktop

# download and install nuclear
#latest_release=$(wget -qO- https://github.com/nukeop/nuclear/releases/latest | grep -oP 'tag/v\K[^"]*' | head -1)
#download_url="https://github.com/nukeop/nuclear/releases/download/v${latest_release}/nuclear-v${latest_release}.deb"
#wget "$download_url" --show-progress -q -O ~/Downloads/Applications/nuclear.deb
#sudo gdebi install ~/Downloads/Applications/nuclear.deb --n

# fix nuclear missing icon
#sudo sed -i 's|^Icon=.*|Icon=/home/bnc/Pictures/Icons/nuclear.png|' /usr/share/applications/nuclear.desktop

# download proton vpn package (manual install with gdebi)
#wget "https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.3-2_all.deb" --show-progress -q -O ~/Downloads/Applications/proton-vpn.deb

# download battle.net.exe (manual install with steam)
#wget --show-progress -qO ~/Downloads/Applications/Battle.net-Setup.exe "https://www.battle.net/download/getInstallerForGame?os=win&gameProgram=BATTLENET_APP&version=Live"

# customize dock and move to left
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position LEFT
gsettings set org.gnome.shell.extensions.dash-to-dock dock-alignment START
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 32
gsettings set org.gnome.shell.extensions.dash-to-dock background-color '#211f1f'
# gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode DYNAMIC # enable dock transparency
gsettings set org.gnome.shell.extensions.dash-to-dock scroll-action switch-workspace
gsettings set org.gnome.shell.extensions.dash-to-dock click-action minimize
gsettings set org.gnome.shell.extensions.dash-to-dock shift-click-action quit
gsettings set org.gnome.shell.extensions.dash-to-dock custom-theme-customize-running-dots false
gsettings set org.gnome.shell.extensions.dash-to-dock running-indicator-style METRO
gsettings set org.gnome.shell.extensions.dash-to-dock running-indicator-dominant-color true
#gsettings set org.gnome.shell favorite-apps "['pop-cosmic-applications.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.gedit.desktop', 'libreoffice-startcenter.desktop', 'simplenote.desktop', 'nuclear.desktop', 'freetube.desktop', 'brave-browser.desktop']"

# install flatpaks
#flatpak install flathub com.github.tchx84.Flatseal -y
#flatpak install flathub io.gitlab.theevilskeleton.Upscaler -y
flatpak install flathub com.mattjakeman.ExtensionManager -y
#flatpak install flathub io.github.Foldex.AdwSteamGtk -y
#flatpak install flathub org.x.Warpinator -y

# install an anime game :)
#flatpak remote-add --user launcher.moe https://gol.launcher.moe/gol.launcher.moe.flatpakrepo
#flatpak install launcher.moe moe.launcher.an-anime-game-launcher -y

# finish
duration=$seconds
endpackages=$(apt list --installed 2>/dev/null | wc -l)
totalpackages=$((endpackages - startpackages))
echo -e "\nThe script installed $totalpackages packages, and took $(($duration / 60)) minutes and $(($duration % 60)) seconds to complete."
echo -e " It is now time to reboot. To do so, just type in the terminal: reboot and hit Enter.\n"

# END
exit
