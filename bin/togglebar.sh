#!/bin/bash
if [[ -z $(pidof i3bar ) ]];then 
    exec /bin/i3bar & disown
    exec /bin/nm-applet & disown
else
    kill -9 $(pidof i3bar)
    kill -9 $(pidof nm-applet)
fi
