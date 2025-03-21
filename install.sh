sudo pacman -Sy
sudo pacman -S i3-wm i3lock xss-lock i3status --noconfirm
sudo pacman -S xorg-server xorg-apps xf86-video-intel libxcb xcb-util xcb-util-keysyms xcb-util-wm xorg xorg-xinit --noconfirm
sudo pacman -S network-manager-applet neofetch ly alacritty firefox zsh --noconfirm

echo "exec i3" >>~/.xinitrx
[ ! -d ~/.config/i3 ] && mkdir -p ~/.config/i3

cat >>~/.config/i3/config <<EOF
set $mod Mod4
set $alt Mod1
font pango:monospace 8
exec --no-startup-id dex --autostart --environment i3
exec --no-startup-id xss-lock --transfer-sleep-lock -- i3lock --nofork
exec --no-startup-id nm-applet

title_align center

gaps outer 0
gaps inner 5

set $refresh_i3status killall -SIGUSR1 i3status
bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10% && $refresh_i3status
bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10% && $refresh_i3status
bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && $refresh_i3status
bindsym XF86AudioMicMute exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status

set $up l
set $down k
set $left j
set $right semicolon

floating_modifier $mod

tiling_drag modifier titlebar

bindsym $mod+Return exec alacritty


bindsym $mod+c kill
bindsym $mod+w exec --no-startup-id firefox

bindsym $mod+d exec --no-startup-id dmenu_run

bindsym $mod+$left focus left
bindsym $mod+$down focus down
bindsym $mod+$up focus up
bindsym $mod+$right focus right

bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right


bindsym $mod+Shift+$left move left
bindsym $mod+Shift+$down move down
bindsym $mod+Shift+$up move up
bindsym $mod+Shift+$right move right


bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right


bindsym $mod+h split h


bindsym $mod+v split v


bindsym $mod+f fullscreen toggle


bindsym $mod+s layout stacking
bindsym $mod+q layout tabbed
bindsym $mod+e layout toggle split

bindsym $mod+Shift+space floating toggle
bindsym $mod+space focus mode_toggle
bindsym $mod+a focus parent

bindsym $mod+Shift+minus move scratchpad

bindsym $mod+minus scratchpad show

set $ws1 "1"
set $ws2 "2"
set $ws3 "3"
set $ws4 "4"
set $ws5 "5"
set $ws6 "6"
set $ws7 "7"
set $ws8 "8"
set $ws9 "9"
set $ws10 "10"

bindsym $mod+1 workspace number $ws1
bindsym $mod+2 workspace number $ws2
bindsym $mod+3 workspace number $ws3
bindsym $mod+4 workspace number $ws4
bindsym $mod+5 workspace number $ws5
bindsym $mod+6 workspace number $ws6
bindsym $mod+7 workspace number $ws7
bindsym $mod+8 workspace number $ws8
bindsym $mod+9 workspace number $ws9
bindsym $mod+0 workspace number $ws10


bindsym $mod+Shift+1 move container to workspace number $ws1
bindsym $mod+Shift+2 move container to workspace number $ws2
bindsym $mod+Shift+3 move container to workspace number $ws3
bindsym $mod+Shift+4 move container to workspace number $ws4
bindsym $mod+Shift+5 move container to workspace number $ws5
bindsym $mod+Shift+6 move container to workspace number $ws6
bindsym $mod+Shift+7 move container to workspace number $ws7
bindsym $mod+Shift+8 move container to workspace number $ws8
bindsym $mod+Shift+9 move container to workspace number $ws9
bindsym $mod+Shift+0 move container to workspace number $ws10


bindsym $mod+Shift+c reload

bindsym $mod+Shift+r restart

bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"


mode "resize" {
    bindsym $left       resize shrink width 10 px or 10 ppt
        bindsym $down       resize grow height 10 px or 10 ppt
        bindsym $up         resize shrink height 10 px or 10 ppt
        bindsym $right      resize grow width 10 px or 10 ppt


        bindsym Left        resize shrink width 10 px or 10 ppt
        bindsym Down        resize grow height 10 px or 10 ppt
        bindsym Up          resize shrink height 10 px or 10 ppt
        bindsym Right       resize grow width 10 px or 10 ppt


        bindsym Return mode "default"
        bindsym Escape mode "default"
        bindsym $mod+r mode "default"
}

bindsym $mod+r mode "resize"

bar {
        status_command i3status
        position top
        font pango:monospace 10
}
exec i3-config-wizard
EOF

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

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

sudo pacman -S base-devel
git clone https://aur.archlinux.org/yay.git
[ -d yay ] || {
    echo "Error occured"
    exit 1
}
cd yay && makepkg -si

sudo systemctl enable ly.service
echo -e "\e[30m=================================================================\e[0m"
echo -e "\e[31m[+]INSTALLATION DONE\e[0m"
echo -e "\e[30m=================================================================\e[0m"
clear
neofetch && echo "\e[30m[Pending] Reboot in 6 seconds... \e[0m" && sleep 6 && sudo reboot
