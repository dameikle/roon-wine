#!/usr/bin/env bash

############################################################
# Helper script to setup Roon 1.8 on Wine in it's own prefix
############################################################

display_help() {
    echo "Roon on Wine Helper Script"
    echo ""
    echo "Usage:"
    echo "    roon_on_wine_helper.sh -h | --help         Display this help message."
    echo "    roon_on_wine_helper.sh -i | --install      Installs Roon. 32-bit by default"
    echo "    roon_on_wine_helper.sh -i32 | --install32  Installs Roon in 32-bit Wine Prefix"
    echo "    roon_on_wine_helper.sh -i64 | --install64  Installs Roon in 64-bit Wine Prefix"
    echo "    roon_on_wine_helper.sh -p | --prefix       Displays the Wine Prefix"
    echo "    roon_on_wine_helper.sh -r | --run          Runs Roon"
    echo ""
    exit 0
}

install_win64() {
	wget -c https://download.roonlabs.com/builds/RoonInstaller64.exe -P /tmp
	env WINEPREFIX=/home/$USER/WineRoon wine wineboot
	env WINEPREFIX=/home/$USER/WineRoon winetricks dotnet48 -q
	env WINEPREFIX=/home/$USER/WineRoon wine /tmp/RoonInstaller64.exe
	rm /tmp/RoonInstaller64.exe
}

install_win32() {
	wget -c https://download.roonlabs.com/builds/RoonInstaller.exe -P /tmp
	env WINEPREFIX=/home/$USER/WineRoon WINEARCH=win32 wine wineboot
	env WINEPREFIX=/home/$USER/WineRoon winetricks dotnet48 -q
	env WINEPREFIX=/home/$USER/WineRoon wine /tmp/RoonInstaller.exe
	rm /tmp/RoonInstaller.exe
}

run_roon() {
	env WINEPREFIX=/home/$USER/WineRoon wine /home/$USER/WineRoon/drive_c/users/$USER/Local\ Settings/Application\ Data/Roon/Application/Roon.exe
}

clean_prefix() {
	rm -R /home/$USER/WineRoon
}

if [ $# -eq 0 ]; then
    display_help
    exit 1
fi

for arg in "$@"
do
    if [ "$arg" == "--help" ] || [ "$arg" == "-h" ]
    then
      display_help
      exit 0
    fi

    if [ "$arg" == "--install" ] || [ "$arg" == "-i" ]
    then
      clean_prefix
      install_win32
      exit 0
    fi

    if [ "$arg" == "--install64" ] || [ "$arg" == "-i64" ]
    then
      clean_prefix
      install_win64
      exit 0
    fi

    if [ "$arg" == "--prefix" ] || [ "$arg" == "-p" ]
    then
      echo "Wine Prefix is '/home/$USER/WineRoon'"
      exit 0
    fi

    if [ "$arg" == "--run" ] || [ "$arg" == "-r" ]
    then
      run_roon
      exit 0
    fi
done
