# Automatically switch to headset microphone | auto-switch-headset-mic.sh

When the headset is connected to the computer, it is correctly configured as the active input device.
Ubuntu does not automatically switch to the microphone input of the headset when it is plugged in, for an average user he will not see that he has remained on his internal microphone, which is problematic in the current period of teleworking when one at meetings, you can hear the noises around.
This script works when the mic inputs are two separate sources.
This script can be added to Ubuntu Startup Applications with a delayed start of a few seconds to ensure there is an internet connection to install all packages. Otherwise the script will still try to run even when offline.
Tested with Linux Mint 20 on Dell Latitude 5400, Dell Latitude 5500, Asus UX410U 16GB, Asus Pro P5440FA, HP EliteBook 845 G7.