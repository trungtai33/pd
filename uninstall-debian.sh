#!/data/data/com.termux/files/usr/bin/bash
if [ "$(uname -o)" != "Android" ]; then
	printf "\n\e[31mError: This script only executes on Termux.\e[0m\n\n"
	exit 1
fi
if [ -z "$(command -v dialog)" ]; then
	printf "\n\e[31mError: 'dialog' is not installed.\e[0m\n\n"
	exit 1
fi
version=$(dialog --title "Debian Uninstaller" --inputbox "Enter the version code name:" 8 50 2>&1 > /dev/tty); clear
if [ -z "${version}" ]; then
	exit 1
fi
directory="debian-${version}"
distribution="Debian (${version})"
if [ ! -d "${PREFIX}/share/${directory}" ]; then
	printf "\n\e[31mError: '${distribution}' not found.\e[0m\n\n"
	exit 1
else
	printf "\n\e[34m[\e[32m*\e[34m]\e[36m Uninstalling ${distribution}, please wait...\e[0m\n"
	rm -rf "${PREFIX}/share/${directory}"
	rm -f "${PREFIX}/bin/start-${directory}"
	printf "\e[34m[\e[32m*\e[34m]\e[36m Uninstall finished.\e[0m\n\n"
fi
