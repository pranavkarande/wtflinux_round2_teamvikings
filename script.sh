#!/bin/bash

if [ "$EUID" -ne 0 ]
then echo "Please run as root"
     exit
fi

# NOTE: Your machine may have different name instead of BATT
BATTERY_PERCENTAGE="$(cat /sys/class/power_supply/BATT/capacity)"
BATTERY_CHARGING="$(cat /sys/class/power_supply/BATT/status)"

if [[ $BATTERY_CHARGING == "Charging" ]]; then
    echo "Connected to AC setting governor to performance"
    echo "performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
elif [[ $BATTERY_PERCENTAGE < 30 ]]; then
    echo "Battery is low setting governor to powersave"
    echo "powersave" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
elif [[ $BATTERY_PERCENTAGE < 50 ]]; then
    echo "Battery is moderately charged setting governor to conservative"
    echo "conservative" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
else
    echo "Battery is well charged setting governor to ondemand"
    echo "ondemand" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
fi
