#!/bin/bash

###################################################################
# Script Name	: Automatically switch to headset microphone | auto-switch-headset-mic.sh
# Description	: When the headset is connected to the computer, it is correctly configured as the active input device.
#                 Ubuntu does not automatically switch to the microphone input of the headset when it is plugged in, for an average user he will not see that he has remained on his internal microphone, which is problematic in the current period of teleworking when one at meetings, you can hear the noises around.
#                 This script works when the mic inputs are two separate sources.
#                 This script can be added to Ubuntu Startup Applications with a delayed start of a few seconds to ensure there is an internet connection to install all packages. Otherwise the script will still try to run even when offline.
#                 Tested with Linux Mint 20 on Dell Latitude 5400, Dell Latitude 5500, Asus UX410U 16GB, Asus Pro P5440FA, HP EliteBook 845 G7.
# Args          : 
# Parameters	: 
# Author	   	: Régis "Sioxox" André
# Email	    	: pro@regisandre.be
# Website		: https://regisandre.be
# Github		: https://github.com/regisandre
###################################################################

RED='\033[1;31m'
GREEN="\033[1;32m"
NC='\033[0m' # No Color

# Check if there is Internet connection
if ping -q -c 1 -W 1 8.8.8.8 > /dev/null; then
	echo -ne "\n${GREEN}Internet connection : OK${NC}\n\n"
    
    # Check if all the need packages and scripts are installed
    # Packages needed : acpid, pulseaudio, coreutils, grep, zenity, zenity-common
    packagesNeeded=(acpid pulseaudio coreutils grep zenity zenity-common)
    packagesThatMustBeInstalled=""
    for pn in ${packagesNeeded[@]}; do
        if [[ $(dpkg -s $pn | grep Status) != *"installed"* ]]; then
            echo -e "${RED}$pn is not installed${NC}"
            packagesThatMustBeInstalled+="$pn "
        fi
    done

    # Automatically install required packages and scripts
    if [[ ! -z "$packagesThatMustBeInstalled" ]]; then
        if zenity --question --title="Confirm automatic installation" --text="Are you sure you want to go ahead and install these programs: $packagesThatMustBeInstalled" --no-wrap 
        then
            sudo apt update && sudo apt install -y $packagesThatMustBeInstalled
        else
            zenity --error --title="Packages needed" --text="These packages must be installed for the script to work" --no-wrap
            echo -ne "\n${RED}These packages must be installed for the script to work${NC}\n\n"
            exit 1
        fi
    fi
else
	echo -ne "${RED}First, connect the computer to the Internet${NC}\n\n"
	zenity --error --title="Internet problem" --text="First, connect the computer to the Internet to install any missing packages" --no-wrap
#	exit 1
fi

# Retrieve the index of the port used to connect the headset
index=$(pacmd list-sources | egrep 'index|ports|analog-input-headset-mic' | egrep '\*\sindex:\s+[0-9]'  | cut -d':' -f2);

# Constantly read the inputs and outputs of an audio device in the jack port
acpi_listen | while IFS= read -r line;
do
    if [ "$line" = "jack/headphone HEADPHONE plug" ]
    then
       pacmd set-source-port $index analog-input-headset-mic;
    elif [ "$line" = "jack/headphone HEADPHONE unplug" ]
    then
       pacmd set-source-port $index analog-input-internal-mic;
    fi
done