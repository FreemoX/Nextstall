#!/bin/bash
#
# Nextstall
# A Linux script meant to make Nextcloud installs easier
#
# Author:  Franz Rolfsvaag
# Version: 0.0.2
# Date:    11 jan 2021
# License: GNU GPL V3
#          https://github.com/FreemoX/Nextstall/blob/main/LICENSE
# GitHub:  https://github.com/FreemoX/Nextstall.git
# 
# Please feel free to improve on this script and use it for your own projects, but leave credit where credit is due.
#
# This script is currently written with Norwegian dialogue. This will be changed in the future
# - - - - - - - - - -

versionL=0  # Major release  | Major changes to Nextstall compared to the previous major release
versionM=0  # Normal release | Feature implementations and new features
versionS=2  # Minor release  | Bug fixes, typo corrections, and similar minor improvements
version=${versionL}.${versionM}.${versionS}

# - - - - - - - - - -
# WARNING
# THIS SCRIPT IS NOT PRODUCTION READY
# Please do not use this script until at least version 0.1.0
# - - - - - - - - - -

initDir=$pwd
choice=-1
no=0
yes=1
nctemp="nextcloud-temp"
ncDownloadURLpre="https://download.nextcloud.com/server/releases/nextcloud-"

# - - - - - - - - - -
# Standardvariabler går over denne linjen
# - - - - - - - - - -

clear
echo "Nextstall versjon $version"
echo " Laget av Franz Rolfsvaag "
echo ""
if [ $versionL -eq 0 ] && [ $versionM -lt 1 ]; then
        echo "             - - - - - - - - - -              "
        echo "                                              "
        echo "                   WARNING                    "
        echo "                                              "
        echo "   !!! This script is NOT ready for use !!!   "
        echo "  Please do not use this until version 0.1.0  "
        echo "This script will NOT work at its current state"
        echo "                                              "
        echo "             - - - - - - - - - -              "
	read -p "Trykk hvilken som helst tast for å dra til neste steg" -n 1 i
fi
echo "Installasjonsskript for Nextcloud"
echo "Husk å kjør dette skriptet som root"
echo ""
echo "Dersom du ikke har gjort det, avbryt og skriv 'sudo !!'"
echo ""
echo ""
echo "Du jobber nå i mappen: $(pwd)"
echo ""
echo "Denne mappen inneholder: " && ls
echo ""
echo ""
echo ""
echo "Du får nå noen valg ..."
echo ""
echo "Gyldige valg er ..."
echo "[$yes] = Ja"
echo "    Du vil bli veiledet gjennom installasjonen"
echo ""
echo "[$no] = Nei"
echo "    Installasjonen vil da avbrytes"
echo ""
echo "Ønsker du å installere Nextcloud?"
read -n 1 choice
if [ $choice -eq $yes ]; then
        echo ""
        echo "Installasjonen vil nå fortsette"
        echo "Trykk 'CTRL + C' for å avbryte installasjonen"
        echo "Dette anbefales da ikke"
        echo ""
        echo " - - - - - "
elif [ $choice -eq $no ]; then
        echo ""
        echo "Installasjonen vil nå avsluttes"
        exit 1
else
        echo ""
        echo "Ditt svar var ugyldig, eller du brukte for lang tid"
        echo "Skriv enter 'J' eller 'N'"
        echo ""
        echo "Installasjonen avbrytes"
        sleep 5
        exit -1
fi
sleep 1
echo ""
echo ""
i=-1
until [ $i -eq $yes ]; do
        clear
        echo "Hvilken Nextcloud versjon ønsker du å installere?"
        echo "Nextstall anbefaler følgende støttede versjoner:"
        echo ""
        grep -v UNSUPPORTED NCversions.txt
        echo ""
        echo "Skriv KUN inn versjonnummer"
        echo ""
        read -p "Jeg ønsker versjon: " ncVersion
        echo "Du ønsker å installere Nextcloud versjon $ncVersion, stemmer dette?"
        ncDownloadURL=$ncDownloadURLpre$ncVersion.zip
        echo ""
        echo "[$yes] = Ja"
        echo "[$no] = Nei"
        echo ""
        read -n 1 i
        echo "Husk at du kan avbryte ved å trykke 'CTRL + C'"
        echo ""
done
echo ""
i=-1
mkdir $nctemp && sleep 1
echo "Opprettet mappen '$nctemp'"
echo "Laster nå ned Nextcloud versjon $ncVersion fra $ncDownloadURL"
cd $nctemp && wget $ncDownloadURL
echo ""
echo "Nextcloud versjon $ncVersion er nå lastet ned"
sleep 2
read -p "Trykk hvilken som helst tast for å dra til neste steg" -n 1 i
i=-1

clear
echo "Installerer nå 'unzip' dersom den mangler"
apt install unzip && wait
sleep 2
until [ $i -eq $yes ]; do
        clear
        echo "Hvor ønsker du at Nextcloud skal være plassert?"
        echo "Standard er '/var/www'"
        echo "Velger du noe annet enn '/var/www' må du gjøre flere endringer selv etter installasjonen"
        echo ""
        read -p "Jeg vil at Nextcloud skal plasseres i: " ncInstallDir
        echo ""
        echo ""
        echo "Er du sikker på at du ønsker å plassere Nextcloud i $ncInstallDir?"
        echo "Det blir tatt en kopi av $ncInstallDir dersom den eksisterer allerede"
        echo "Kopien blir kalt $ncInstallDir.backup"
        echo "[$yes] = Ja"
        echo "[$no] = Nei"
        read -n 1 i
done
read -p "Trykk hvilken som helst tast for å dra til neste steg" -n 1 i
i=-1

clear
echo "Er du helt sikker på at du ønsker å plassere Nextcloud i $ncInstallDir?"
echo "Husk at det vanligste er å plassere Nextcloud i '/var/www'"
read -p "Trykk hvilken som helst tast for å dra til neste steg" -n 1 i
i=-1
echo ""
echo "Plasserer nå Nextcloud i $ncInstallDir"
echo "Lager en kopi av $ncInstallDir dersom den eksisterer allerede"
mv $ncInstallDir $ncInstallDir.backup && wait
mkdir $ncInstallDir && wait
echo ""
echo "Pakker ut Nextcloud i en midlertidig mappe"
mkdir nextcloud
unzip nextcloud-$ncVersion.zip && wait
echo ""
echo "!!! VIKTIG !!!"
echo "Dette er siste sjanse å angre dersom du har valgt feil mappe"
read -p "Trykk hvilken som helst tast for å dra til neste steg" -n 1 i
i=-1
echo ""
echo ""
echo "Plasserer nå Nextcloud i $ncInstallDir"
mv nextcloud/* $ncInstallDir && wait
read -p "Trykk hvilken som helst tast for å dra til neste steg" -n 1 i
i=-1

clear
echo "Fjerner nå gamle filer og mapper fra installasjonen" && sleep 1
echo ""
cd .. && mkdir oldZips && mv $nctemp/*.zip oldZips/
rm -r $nctemp && wait
echo "Fjernet mappen '$nctemp'"
sleep 2
read -p "Trykk hvilken som helst tast for å dra til neste steg" -n 1 i
i=-1

clear
echo "Installerer nå apache2 og apache2-utils"
echo ""
sudo apt install -y apache2 apache2-utils && wait
sudo systemctl start apache2 && sudo systemctl enable apache2
echo ""
echo "Nextstall har nå installert følgende versjon av Apache 2"
apache2 -v
echo ""
echo "Installerer nå PHP7.4"
sudo apt install php7.4 libapache2-mod-php7.4 php7.4-mysql php-common php7.4-cli php7.4-common php7.4-json php7.4-opcache php7.4-readline
sudo a2enmod php7.4 && sudo systemctl restart apache2
echo ""
echo "Nextstall har nå installert følgende versjon av PHP:"
php --version
sleep 3
echo "Åpner nå port 80 for HTTP trafikk"
sudo ufw allow http && wait
echo ""
echo ""
echo "Du kan nå dra til denne serverens IP adresse for å se om webserveren er oppe"
echo "Ikke lukk dette vinduet enda"
echo ""
echo ""
echo "Gir Apache2 rettigheter til $ncInstallDir"
sudo chown www-data:www-data $ncInstallDir -R
sleep 2
read -p "Trykk hvilken som helst tast for å dra til neste steg" -n 1 i
i=-1

clear
echo "Installerer nå MariaDB"
echo ""
sudo apt install mariadb-server mariadb-client
sudo systemctl start mariadb && sudo systemctl enable mariadb
echo ""
echo "- - - - - - - - - -"
echo "Bekreft at Apache2 og MariaDB kjører"
echo "Om ikke, avbryt skriptet med 'CTRL + C'"
systemctl status apache2 | grep active
systemctl status mariadb | grep active
echo "- - - - - - - - - -"
sleep 5
read -p "Trykk hvilken som helst tast for å dra til neste steg" -n 1 i
i=-1

clear
echo "Dette skriptet er nå ferdig"
echo ""
echo "Ikke lukk dette skriptet før du har fått med deg informasjonen du behøver for siste del av installasjonen"
echo ""
echo ""
echo "Her har du en liten gjennomgang av hva som er gjort ..."
echo "Du har kjørt dette skriptet fra $(pwd)"
echo "Du har installert Nextcloud $ncVersion i $ncInstallDir"
echo "En kopi av den originale $ncInstallDir er laget, og den heter '$ncInstallDir.backup'"
echo ""
echo "Du kan nå denne serveren gjennom følgende IP-adresse(r):"
ip addr show | grep inet | grep -v inet6
# - - - - - - - - - -
# Avvent tastetrykk før skriptet lukkes
# - - - - - - - - - -
echo ""
echo ""
echo ""
echo ""
read -p "Trykk hvilken som helst tast for å lukke dette skriptet" -n 1 i
i=-1
clear
exit 1
