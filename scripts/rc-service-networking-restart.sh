touch /tmp/rc-service-network-restarting

notify-send -t 3000 --icon=$XDG_CONFIG_HOME/sway/icons/Wifi.jpg Reconnecting...

cat /home/taham/.sudo-pass | sudo -S -p "" -E env "PATH=$PATH" \
    rc-service networking restart

rm -rf /tmp/rc-service-network-restarting

notify-send -t 3000 --icon=$XDG_CONFIG_HOME/sway/icons/Wifi.jpg Reconnected.
