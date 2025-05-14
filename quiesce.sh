#!/bin/bash

sudo systemctl mask bluetooth
sudo systemctl stop snapd bluetooth cron cups avahi-daemon NetworkManager docker 
sudo cpupower frequency-set -g performance

