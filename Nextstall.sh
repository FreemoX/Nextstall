#!/bin/bash
#
# Nextstall
# A Linux script meant to make Nextcloud installs easier
#
# Author:  Franz Rolfsvaag
# Version: 0.0.1
# Date:    11 jan 2021
# License: GNU GPL V3
# GitHub:  https://github.com/FreemoX/Nextstall.git
# 
# Please feel free to improve on this script and use it for your own projects, but leave credit where credit is due.
#
# This script is currently written with Norwegian dialogue. This will be changed in the future
# - - - - - - - - - -

versionL=0
versionM=0
versionS=1
version=${versionL}.${versionM}.${versionS}

# - - - - - - - - - -
# WARNING
# THIS SCRIPT IS NOT PRODUCTION READY
# Please do not use this script until at least version 0.1.0
# - - - - - - - - - -

initDir=$pwd
valg=-1
nei=0
ja=1
nctemp="nextcloud-temp"
ncDownloadURLpre="https://download.nextcloud.com/server/releases/nextcloud-"

# - - - - - - - - - -
# Standardvariabler går over denne linjen
# - - - - - - - - - -

clear
echo "Nextstall versjon $version"
echo ""
if [ $versionM -lt 1 ] && [ $versionL -lt 1 ]; then
        echo "             - - - - - - - - - -              "
        echo ""
        echo "                   WARNING                    "
        echo ""
        echo "   !!! This script is NOT ready for use !!!   "
        echo "  Please do not use this until version 0.1.0  "
        echo "This script will NOT work at its current state"
        echo ""
        echo "             - - - - - - - - - -              "
        sleep 10
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
echo "["$ja"] = Ja"
echo "    Du vil bli veiledet gjennom installasjonen"
echo ""
echo "[$nei] = Nei"
echo "    Installasjonen vil da avbrytes"
echo ""
echo "Ønsker du å installere Nextcloud?"
read -n 1 valg
if [ $valg -eq $ja ]; then
        echo ""
        echo "Installasjonen vil nå fortsette"
        echo "Trykk 'CTRL + C' for å avbryte installasjonen"
        echo "Dette anbefales da ikke"
        sleep 2
        echo " - - - - - "
elif [ $valg -eq $nei ]; then
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
until [ $i -eq $ja ]; do
        clear
        echo "Hvilken Nextcloud versjon ønsker du å installere?"
        echo "Eksempelvis: 20.0.4"
        echo "Skriv KUN inn versjonnummer"
        echo ""
        read -p "Jeg ønsker versjon: " ncVersjon
        echo "Du ønsker å installere Nextcloud versjon $ncVersjon, stemmer dette?"
        ncDownloadURL=$ncDownloadURLpre$ncVersjon.zip
        echo ""
        echo "[$ja] = Ja"
        echo "[$nei] = Nei"
        echo ""
        read -n 1 i
        echo "Husk at du kan avbryte ved å trykke 'CTRL + C'"
done
i=-1
mkdir $nctemp && sleep 1
echo "Opprettet mappen '$nctemp'"
echo "Laster nå ned Nextcloud versjon $ncVersjon fra $ncDownloadURL"
cd $nctemp && wget $ncDownloadURL
#cd $nctemp && mkdir ncTestNedlasting
echo ""
echo "Nextcloud versjon $ncVersjon er nå lastet ned"
sleep 2

clear
echo "Installerer nå 'unzip' dersom den mangler"
apt install unzip && wait
sleep 2
until [ $i -eq $ja ]; do
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
        echo "[$ja] = Ja"
        echo "[$nei] = Nei"
        read -n 1 i
done
i=-1

clear
echo "Er du helt sikker på at du ønsker å plassere Nextcloud i $ncInstallDir?"
echo "Om ikke, trykk 'CTRL + C' innen 15 sekunder for å avbryte installasjonen" && sleep 15
echo ""
echo ""
echo "Plasserer nå Nextcloud i $ncInstallDir"
echo "Lager en kopi av $ncInstallDir dersom den eksisterer allerede"
mv $ncInstallDir $ncInstallDir.backup && wait
mkdir $ncInstallDir && wait
echo ""
echo "Pakker ut Nextcloud i en midlertidig mappe"
mkdir nextcloud
unzip nextcloud-$ncVersjon.zip && wait
echo ""
echo "!!! VIKTIG !!!"
echo "Dette er siste sjanse å angre dersom du har valgt feil mappe"
echo "Dersom du angrer, trykk 'CTRL + C' innen 15 sekunder" && sleep 5
echo "10 sekunder igjen" && sleep 5
echo "5 sekunder igjen" && sleep 1
echo "4 sekunder igjen" && sleep 1
echo "3 sekunder igjen" && sleep 1
echo "2 sekunder igjen" && sleep 1
echo "1 sekund igjen" && sleep 1
echo ""
echo ""
echo "Plasserer nå Nextcloud i $ncInstallDir"
mv nextcloud/* $ncInstallDir && wait

clear
echo "Fjerner nå gamle filer og mapper fra installasjonen" && sleep 1
echo ""
cd .. && mkdir oldZips && mv $nctemp/*.zip oldZips/
rm -r $nctemp && wait
echo "Fjernet mappen '$nctemp'"

clear
echo "Dette skriptet er nå ferdig"
echo ""
echo "Nå må du gjøre litt på egen hånd"
echo "Du kan nå fullføre installasjonen ved å dra til denne serveren sin IP adresse med en nettleser"
echo "Ikke lukk dette skriptet før du har fått med deg informasjonen du behøver for siste del av installasjonen"
echo ""
echo ""
echo "Her har du en liten gjennomgang av hva som er gjort ..."
echo "Du har kjørt dette skriptet fra $(pwd)"
echo "Du har installert Nextcloud $ncVersjon i $ncInstallDir"
echo "En kopi av den originale $ncInstallDir er laget, og den heter '$ncInstallDir.backup'"
# - - - - - - - - - -
# Avvent tastetrykk før skriptet lukkes
# - - - - - - - - - -
echo ""
echo ""
echo ""
echo ""
read -p "Trykk hvilken som helst tast for å lukke dette skriptet" -n 1 i
exit 1
