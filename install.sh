sudo pacman -S i3-wm i3lock xss-lock i3status 
sudo pacman -S xorg-server xorg-apps xf86-video-intel libxcb xcb-util xcb-util-keysyms xcb-util-wm xorg xorg-xinit
sudo pacman -S network-manager-applet neofetch ly alacritty firefox zsh feh  maim

if [[ -f "$HOME/.xinitrx" ]];then
    cp "$HOME/.xinitrc" "$HOME/.xinitrc_backup"
fi

if [[ ! -f "$HOME/.wallpaper.jpg" ]];then
    cp -r ./wallpaper.jpg "$HOME/.wallpaper.jpg" 
fi

echo "exec i3" > "$HOME/.xinitrc"
[ ! -d ~/.config/i3 ] && mkdir -p ~/.config/i3

cp -r bin ~/.config/

cat >>~/.config/i3/config <<EOF
##-- Mod Keys ----------------------------
set \$mod Mod4
set \$alt Mod1

##-- Fonts (Global) ----------------------
font pango:JetBrains Mono Medium 5

##-- Gaps --------------------------------

# Title bar text alignment
title_align center

bar {
        status_command i3status
        position top
        font pango:monospace 10
}

# Uncomment this to enable title bars
#for_window [class=".*"] border normal 4

# Uncomment this to disable title bars
for_window [class=".*"] border pixel 2

# Gaps (Outer gaps are added to the inner gaps)
gaps inner 5
gaps outer 0

#Only enable gaps on a workspace when there is at least one container
# smart_gaps on

# Activate smart borders (always)
# smart_borders on

##-- Colors ------------------------------

include ~/.config/i3/i3colors

##-- Autostart ---------------------------
exec --no-startup-id dex --autostart --environment i3
exec --no-startup-id nm-applet
exec --no-startup-id feh --bg-scale ~/.wallpaper.jpg
exec_always --no-startup-id     xss-lock -- "\$HOME/.config/bin/lockscreen" --transfer-sleep-lock --nofork

##-- Key Bindings ------------------------

# -- Terminal --
bindsym \$mod+Return 			exec --no-startup-id "~/.config/bin/i3term.sh"
bindsym \$mod+Shift+Return 		exec --no-startup-id "~/.config/bin/i3term.sh --float"

# -- Apps --
bindsym \$mod+Shift+e 			exec --no-startup-id virt-manager
bindsym \$mod+Shift+w 			exec --no-startup-id firefox-developer-edition
bindsym \$mod+w 					exec --no-startup-id firefox
bindsym \$mod+Shift+a 			exec --no-startup-id telegram-desktop
bindsym \$mod+a 			        exec --no-startup-id telegram-desktop
bindsym \$mod+z       			exec --no-startup-id discord
bindsym \$mod+q 					exec --no-startup-id whatsie
bindsym \$alt+Control+r 			exec --no-startup-id "alacritty --config-file ~/.config/alacritty/alacritty.yml -e ranger"
bindsym \$alt+Control+h 			exec --no-startup-id "alacritty --config-file ~/.config/alacritty/alacritty.yml -e htop"
bindsym \$mod+Control+l          exec --no-startup-id ~/.config/bin/lockscreen
bindsym \$mod+Control+t          exec --no-startup-id ~/.config/bin/toggletouchpad

# -- Rofi --
bindsym \$mod+d  				exec --no-startup-id dmenu_run
bindsym \$mod+n 					exec --no-startup-id networkmanager_dmenu
bindsym \$mod+Shift+t            exec --no-startup-id "~/.config/bin/togglebar.sh"
bindsym \$mod+t                  exec --no-startup-id  "~/.config/bin/mpc-toggle"

# -- Function keys --
bindsym XF86MonBrightnessUp 	exec --no-startup-id "~/.config/bin/brightness --inc"
bindsym XF86MonBrightnessDown 	exec --no-startup-id "~/.config/bin/brightness --dec"
bindsym XF86AudioRaiseVolume 	exec --no-startup-id "~/.config/bin/volume --inc"
bindsym XF86AudioLowerVolume 	exec --no-startup-id "~/.config/bin/volume --dec"
bindsym XF86AudioMute 			exec --no-startup-id "~/.config/bin/volume --toggle"
bindsym XF86AudioMicMute 		exec --no-startup-id "~/.config/bin/volume --toggle-mic"
bindsym XF86AudioNext 			exec --no-startup-id "mpc next"
bindsym XF86AudioPrev 			exec --no-startup-id "mpc prev"
bindsym XF86AudioPlay 			exec --no-startup-id "mpc toggle"
bindsym XF86AudioStop 			exec --no-startup-id "mpc stop"

# -- Screenshots --
bindsym Print 					exec --no-startup-id "~/.config/bin/takeshot --now"
bindsym \$mod+Print 				exec --no-startup-id "~/.config/bin/takeshot --in5"
bindsym Shift+Print 			exec --no-startup-id "~/.config/bin/takeshot --in10"
bindsym Control+Print 			exec --no-startup-id "~/.config/bin/takeshot --win"
bindsym \$mod+Control+Print 		exec --no-startup-id "~/.config/bin/takeshot --area"

# -- i3wm --

# Lockscreen
bindsym \$alt+Control+l 			exec --no-startup-id ~/.config/bin/lockscreen

# Use Mouse+\$mod to drag floating windows to their wanted position
floating_modifier \$mod

# kill focused window
bindsym \$mod+c kill

# change focus
bindsym \$mod+j focus left
bindsym \$mod+k focus down
bindsym \$mod+l focus up
bindsym \$mod+semicolon focus right

# alternatively, you can use the cursor keys:
bindsym \$mod+Left focus left
bindsym \$mod+Down focus down
bindsym \$mod+Up focus up
bindsym \$mod+Right focus right

# move focused window
bindsym \$mod+Shift+j move left
bindsym \$mod+Shift+k move down
bindsym \$mod+Shift+l move up
bindsym \$mod+Shift+semicolon move right

# alternatively, you can use the cursor keys:
bindsym \$mod+Shift+Left move left
bindsym \$mod+Shift+Down move down
bindsym \$mod+Shift+Up move up
bindsym \$mod+Shift+Right move right

# switch between active workspaces 
bindsym \$alt+Control+Left workspace next
bindsym \$alt+Control+Right workspace prev 

# split in horizontal orientation
bindsym \$mod+h split h
# split in vertical orientation
bindsym \$mod+v split v

# enter fullscreen mode for the focused container
bindsym \$mod+f fullscreen toggle

# change container layout (stacked, tabbed, toggle split)
bindsym \$mod+Shift+z layout stacking
bindsym \$mod+Shift+x layout tabbed
bindsym \$mod+Shift+c layout toggle split

# toggle tiling / floating
bindsym \$mod+space floating toggle

# change focus between tiling / floating windows
bindsym \$mod+Shift+space focus mode_toggle

# focus the parent container
bindsym \$mod+Shift+p focus parent

# focus the child container
bindsym \$mod+p focus child

##-- Workspaces ---------------------

# Define names for default workspaces for which we configure key bindings later on.
# We use variables to avoid repeating the names in multiple places.
set \$ws1 "1"
set \$ws2 "2"
set \$ws3 "3"
set \$ws4 "4"
set \$ws5 "5"
set \$ws6 "6"

# switch to workspace
bindsym \$mod+1 workspace number \$ws1
bindsym \$mod+2 workspace number \$ws2
bindsym \$mod+3 workspace number \$ws3
bindsym \$mod+4 workspace number \$ws4
bindsym \$mod+5 workspace number \$ws5
bindsym \$mod+6 workspace number \$ws6

# move focused container to workspace
bindsym \$mod+Shift+1 move container to workspace number \$ws1
bindsym \$mod+Shift+2 move container to workspace number \$ws2
bindsym \$mod+Shift+3 move container to workspace number \$ws3
bindsym \$mod+Shift+4 move container to workspace number \$ws4
bindsym \$mod+Shift+5 move container to workspace number \$ws5
bindsym \$mod+Shift+6 move container to workspace number \$ws6

# reload the configuration file
bindsym Control+\$alt+c reload
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
bindsym Control+Shift+r restart
# quit i3 session
bindsym Control+Shift+q exit

##-- Resize / Move / Gaps ------------------------

# resize window (you can also use the mouse for that)
mode "Resize" {
        # These bindings trigger as soon as you enter the resize mode

        bindsym Left resize shrink width 10 px or 10 ppt
        bindsym Down resize grow height 10 px or 10 ppt
        bindsym Up resize shrink height 10 px or 10 ppt
        bindsym Right resize grow width 10 px or 10 ppt

        # back to normal: Enter or Escape or \$mod+r
        bindsym Return mode "default"
        bindsym Escape mode "default"
        bindsym \$mod+r mode "default"
}
bindsym \$mod+Shift+r mode "Resize"

mode "Move" {
        # These bindings trigger as soon as you enter the Move mode

        bindsym Left move left 20px
        bindsym Down move down  20px
        bindsym Up move up 20px
        bindsym Right move right 20px

        # back to normal: Enter or Escape or \$mod+r
        bindsym Return mode "default"
        bindsym Escape mode "default"
        bindsym \$mod+m mode "default"
}
bindsym \$mod+Shift+m mode "Move"

set \$mode_gaps Gaps: (o)uter, (i)nner
set \$mode_gaps_outer Outer Gaps: +|-|0 (local), Shift + +|-|0 (global)
set \$mode_gaps_inner Inner Gaps: +|-|0 (local), Shift + +|-|0 (global)

mode "\$mode_gaps_outer" {
        bindsym plus  gaps outer current plus 5
        bindsym minus gaps outer current minus 5
        bindsym 0     gaps outer current set 0

        bindsym Shift+plus  gaps outer all plus 5
        bindsym Shift+minus gaps outer all minus 5
        bindsym Shift+0     gaps outer all set 0

        bindsym Return mode "\$mode_gaps"
        bindsym Escape mode "default"
}

mode "\$mode_gaps_inner" {
        bindsym plus  gaps inner current plus 5
        bindsym minus gaps inner current minus 5
        bindsym 0     gaps inner current set 0

        bindsym Shift+plus  gaps inner all plus 5
        bindsym Shift+minus gaps inner all minus 5
        bindsym Shift+0     gaps inner all set 0

        bindsym Return mode "\$mode_gaps"
        bindsym Escape mode "default"
}

mode "\$mode_gaps" {
        bindsym o      mode "\$mode_gaps_outer"
        bindsym i      mode "\$mode_gaps_inner"
        bindsym Return mode "\$mode_gaps"
        bindsym Escape mode "default"
}

bindsym \$mod+Shift+g mode "\$mode_gaps"

##-- Workspace Rules ------------------------
# assign [class="Lxappearance|Nitrogen"] 6
# assign [class="Pavucontrol|Xfce4-power-manager-settings"] 6

##-- Window Rules ------------------------
for_window [window_role="pop-up"] floating enable
for_window [window_role="task_dialog"] floating enable
for_window [class="alacritty-float"] floating enable
for_window [class="Pcmanfm|Onboard|Yad"] floating enable
for_window [class="Lxappearance|Nitrogen"] floating enable
for_window [class="Pavucontrol|Xfce4-power-manager-settings|Nm-connection-editor"] floating enable
for_window [class="feh|Viewnior|Gpicview|Gimp|MPlayer"] floating enable
for_window [class="Kvantum Manager|qt5ct"] floating enable
for_window [class="VirtualBox Manager|qemu|Qemu-system-x86_64"] floating enable
EOF



if [[ ! -f "$HOME/.zshrc" ]];then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [[ ! -z $(ls /etc/X11/xorg.conf.d | grep touchpad ) ]];then
cat <<EOF | sudo tee /etc/X11/xorg.conf.d/70-touchpad.conf
Section "InputClass"
    Identifier "touchpad"
    Driver "libinput"
    MatchIsTouchpad "on"
	Option "Tapping" "on"
	Option "ClickMethod" "clickfinger"
	Option "NaturalScrolling" "true"
EndSection
EOF
fi

echo "\e[30m [IMPORTANT] If this fails , a backup file of your pacman.conf has been created in /tmp/pacman.conf-backup\e[0m"
cp /etc/pacman.conf /tmp/pacman.conf-backup

sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

if [ $? != 0 ]; then
    echo "Something failed, File not edited yet, exiting..."
    exit 1
fi

sudo sed -i "s|\#\[multilib-testing\]|\[chaotic-aur\]\nInclude = /etc/pacman.d/chaotic-mirrorlist\n\n\#\[multilib-testing\]|g" /etc/pacman.conf
sudo pacman -Syy

# -- installing light
sudo pacman -S light
sudo usermod -aG video $USER

sudo pacman -S base-devel


if [[ ! -f /bin/yay ]];then
	git clone https://aur.archlinux.org/yay.git
	[ -d yay ] || {
	    echo "Error occured"
	    exit 1
	}
	cd yay && makepkg -si
fi

echo "install ly display manager?[N,y]"
read ans
if [[ $ans == "Y" ]] || [[ $ans == "y" ]];then
	echo okay
else
	exit 0
fi

sudo systemctl enable ly.service
echo -e "\e[30m=================================================================\e[0m"
echo -e "\e[31m[+]INSTALLATION DONE\e[0m"
echo -e "\e[30m=================================================================\e[0m"
clear


neofetch && echo "\e[30m[Pending] Reboot in 6 seconds... \e[0m" && sleep 6 && sudo reboot
