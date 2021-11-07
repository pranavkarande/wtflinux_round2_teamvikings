#!/bin/bash

if [ "$EUID" -ne 0 ]
then echo "Please run as root"
     exit
fi

BATTERY_PERCENTAGE="$(cat /sys/class/power_supply/BATT/capacity)"
BATTERY_CHARGING="$(cat /sys/class/power_supply/BATT/status)"

if [[ $BATTERY_CHARGING == "Charging" ]]; then
    echo "Battery is charging setting governor to performance"
    echo "performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq
elif [[ $BATTERY_PERCENTAGE == 100 ]]; then
    echo "Battery is fully charged setting governor to conservative"
    echo "conservative" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq
elif [[ $BATTERY_PERCENTAGE < 30 ]]; then
    echo "Battery is low setting governor to powersave"
    echo "poewersave" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq
fi
