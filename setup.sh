#!/usr/bin/env bash

#color
cyan='\e[1;36m'
pink='\e[1;35m'
green='\e[1;34m'
oakgreen='\033[92m'
lightgreen='\e[1;32m'
white='\e[1;37m'
red='\e[1;31m'
yellow='\e[1;33m'
BlueF='\e[1;34m' #Biru
RESET="\033[00m" #normal
orange='\e[38;5;166m'

#Variables 

UID_ROOT=0     
E_NONROOT=67   
dir=0

resize -s 44 85
clear
echo -e $red "  .d8888b.                    888                           .d8888b.  888     888 "
echo -e $red " d88P  Y88b                   888                          d88P  Y88b 888     888 "
echo -e $red " Y88b.                        888                          Y88b.      888     888 "
echo -e $red "  'Y888b.   888  888 .d8888b  888888 .d88b.  88888b.d88b.   'Y888b.   888     888 "
echo -e $red "     'Y88b. 888  888 88K      888   d8P  Y8b 888 '888 '88b     'Y88b. 888     888 "
echo -e $red "       '888 888  888 'Y8888b. 888   88888888 888  888  888       '888 888     888 "		
echo -e $red " Y88b  d88P Y88b 888      X88 Y88b. Y8b.     888  888  888 Y88b  d88P Y88b. .d88P  "
echo -e $red "  'Y8888P'   'Y88888  88888P'  'Y888 'Y8888  888  888  888  'Y8888P'   'Y88888P' "
echo -e $red "                 888 "
echo -e $red "            Y8b d88P "
echo -e $red "              'Y88P' "
echo
sleep 0.5


echo -e "	 		$red checking dependencies"
sleep 1
echo 
echo

#Check internet connexion
echo -e $yellow "[*] Checking Internet Connexion ...."
sleep 2
echo ""
ping -c 1 8.8.4.4 > /dev/null 2>&1
png="$?"
 if [ $png == "0" ]
then
    echo -e "$oakgreen [✔]::[Internet]: connexion found!"
    sleep 1
    echo ""
elif [ $png == "1" ]
then
    echo -e $yellow "$red [!]::You are connected to your local network but not to the Internet ."
    echo ""
    echo -e $red "$red [!]::You need to be connected to install SystemSU."
    echo ""
    sleep 1
	echo -e $BlueF "Script dev by Théodore Prévot."
	echo -e $BlueF "Good bye..."
	sleep 1
	exit 0
elif [ $png == "2" ]
then
	echo -e $red "$red [!]::You are not connected to the Internet."
	echo ""
	echo -e $red "$red [!]::You need to be connected to install SystemSU."
	echo ""
	sleep 1
	echo -e $BlueF "Script dev by Théodore Prévot."
	echo -e $BlueF "Good bye..."
	sleep 1
	exit 0
fi

#Check root
if [ "$UID" -ne "$UID_ROOT" ]
then
	echo -e "$red [x]::[warning]:this script requires root access to run"
	exit $E_NONROOT
else
	echo -e "$oakgreen [✔]::[Root]: Root access granted!"
	sleep 0.5
	echo ""
fi

#installation of the dependencies

#Check if Nmap exists
which nmap > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
	echo -e $oakgreen "[✔]::[Nmap]: Installation found!"
	sleep 0.7
	echo ""
else
   	echo -e $red "[x]::[warning]:Nmap is not installed!"
   	echo -e $yellow " [*] Installing Nmap..."
   	sudo apt-get install nmap -y > /dev/null
   	which nmap > /dev/null 2>&1
   	echo
	if [ "$?" -eq "0" ]; then
		echo -e $oakgreen "[✔]::[Nmap]: Installation found!"
		echo
	else
		clear
		echo
		echo -e $red "$red [!]::Nmap installation failed!"
		echo -e $red " Install Nmap manually"
		echo
	fi
fi

#Check if Geoip exists
which  geoiplookup > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
	echo -e $oakgreen "[✔]::[GeoIP]: Installation found!"
	sleep 1
	echo ""
else
   echo -e $red "[x]::[warning]:GeoIP is not installed!"
   echo -e $yellow " [*] Installing GeoIP..."
   sudo apt-get install geoip-bin -y > /dev/null
   which geoiplookup > /dev/null 2>&1
   if [ "$?" -eq "0" ]; then
   		echo
		echo -e $oakgreen "[✔]::[GeoIP]: Installation found!"
		echo
	else
		clear
		echo
		echo -e $red "$red [!]::The Installation of GeoIP failed!"
		echo -e $red " Install GeoIP manually"
		sleep 1
		exit 1
	fi
fi

#Check if GeoLiteCity exists
test -f /usr/share/GeoIP/GeoLiteCity.dat
if [ "$?" -eq "0" ]; then
	echo -e $oakgreen "[✔]::[GeoLiteCity]: Installation found!"
	sleep 1
	echo ""
else
   	echo -e "$red [x]::[warning]:GeoLiteCity is not installed!"
   	echo -e $yellow " [*] Installing GeoLiteCity..."
   	echo
   	sudo wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz &> /dev/null
   	sudo gunzip GeoLiteCity.dat.gz
   	sudo mv GeoLiteCity.dat /usr/share/GeoIP/
   	test -f /usr/share/GeoIP/GeoLiteCity.dat
	if [ "$?" -eq "0" ]; then
		echo -e $oakgreen "[✔]::[GeoLiteCity]: Installation found!"
		echo
	else
		clear
		echo -e $red "$red [!]::The Installation of GeoLiteCity failed!"
		echo -e $red " Install GeoLiteCity manually"
		sleep 1
		exit 1
fi
fi
#Création d'un lien symbolique
echo -e $yellow "[*] Creation of a link..."
dir=`pwd`
cd /usr/bin/
rm systemsu
ln -s $dir/SystemSU systemsu
cd $dir
test -f /usr/bin/systemsu
if [ "$?" -eq "0" ]; then
	echo
	echo -e $oakgreen "[✔]::Link created!"
	sleep 1
	echo ""
else
   	echo -e "$red [x]::[warning]:The link could not be created !"
   	echo ""
fi
sleep 1
echo
echo
echo -e $green "Just type systemsu in your terminal as root User to run the program"
sleep 0.5
echo -e $green "If you change the directory of SystemSU, rerun setup.sh to recreate a link"
sleep 2
echo
echo -e $green "End of the script..."
chmod 777 SystemSU
sleep 1
exit 1



