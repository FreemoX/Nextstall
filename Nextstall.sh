#!/bin/bash
#
# Nextstall
# A Linux script meant to make Nextcloud installs easier
#
# Author:  Franz Rolfsvaag
# Version: 0.0.3
# Date:    11 jan 2021
# License: GNU GPL V3
#          https://github.com/FreemoX/Nextstall/blob/main/LICENSE
# GitHub:  https://github.com/FreemoX/Nextstall.git
# 
# Please feel free to improve on this script and use it for your own projects, but leave credit where credit is due.
########################################################

##############################################################
#                          WARNING                           #
#            THIS SCRIPT IS NOT PRODUCTION READY             #
# Please do not use this script until at least version 0.1.0 #
##############################################################

versionL=0  # Major release  | Major changes to Nextstall compared to the previous major release
versionM=0  # Normal release | Feature implementations and new features
versionS=3  # Minor release  | Bug fixes, typo corrections, and similar minor improvements
version=${versionL}.${versionM}.${versionS}

installDeps=(	# Lists the dependancies Nextstall needs to function
	"unzip"
	"wget"
)

installSoft=(	# Lists the software needed to run Nextcloud
	"apache2"
	"apache2-utils"
	"mariadb-server"
	"mariadb-client"
	"certbot"
	"python3-certbot-apache"
	"redis-server"
)

installMods=(	# Lists the needed modules for optimal performance
	"php-imagick"
	"php7.4"
	"php7.4-cli"
	"php-common"
	"php7.4-opcache"
	"php7.4-readline"
	"libapache2-mod-php7.4"
	"php7.4-common"
	"php7.4-mysql"
	"php7.4-fpm"
	"php7.4-gd"
	"php7.4-json"
	"php7.4-curl"
	"php7.4-zip"
	"php7.4-xml"
	"php7.4-mbstring"
	"php7.4-bz2"
	"php7.4-intl"
	"php7.4-bcmath"
	"php7.4-gmp"
	"php7.4-zip"
	"php-redis"
)

installAll="${installDeps[@]} ${installSoft[@]} ${installMods[@]}"

apacheVersion="$(sudo apachectl -v)"
phpVersion="$(sudo php --version)"
mariadbVersion="$(sudo mysql --version)"

initDir=""
initDir+="$(pwd)"
choice=-1
no=0
yes=1
nctemp="nextcloud-temp"
ncDownloadURLpre="https://download.nextcloud.com/server/releases/nextcloud-"

########################################################
#               End of default variables               #
########################################################

########################################################
#                  Nextstall functions                 #
########################################################

press_any_to_continue () {
	read -p "Press any key to continue" -n 1 i
	i=-1
}

display_version_warning () {
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
        	echo ""
		press_any_to_continue
		echo ""
		echo ""
		echo ""
	fi
}

########################################################
#              End of Nextstall functions              #
########################################################

clear
echo "Nextstall version $version"
echo "Made by Franz Rolfsvaag"
echo ""
display_version_warning
echo "Nextstall is a shell script made to simplify the installation of Nextcloud"
echo ""
echo "Nextstall is currently only intended to be used for installing Nextcloud"
echo "on a fresh OS install. Proceeding on an existing system is at your own risk"
echo "Currently tested on: UBUNTU 20.04"
echo ""
echo "NOTE THERE ARE NO SAFETY FEATURES CURRENTLY BUILT INTO NEXTSTALL"
echo "MISUSE MAY SERIOUSLY DAMAGE YOUR OS INSTALL"
echo ""
echo ""
echo "Make sure you run Nextstall with sudo permissions"
echo ""
echo "If you haven't done so, abort and run 'sudo !!'"
echo ""
echo ""
echo "You are currently working in the following directory: $(pwd)"
echo ""
echo "This directory contains the following files: " && ls
echo ""
echo ""
echo ""
echo "Accepted responses are ..."
echo "[$yes] = Yes"
echo "    You will be guided through the installation procedure"
echo ""
echo "[$no] = No"
echo "    The installation will abort"
echo ""
echo "Do you wish to install Nextcloud?"
read -n 1 choice
if [ $choice -eq $yes ]; then
        echo ""
        echo "Just making sure. We'll continue the installation now"
        echo "Remember that you can press 'CTRL + C' at any time to abort"
elif [ $choice -eq $no ]; then
        echo ""
        echo "That's fine. Come back and press $yes when you are ready"
        exit 1
else
        echo ""
        echo "Your answer was invalid ..."
        echo "Valid responses are '$yes' yes, and '$no' no"
        echo ""
        echo "We'll just exit this for now. Better safe than sorry"
        sleep 5
        exit -1
fi
sleep 1
clear

########################################################
#                  Nextcloud Version                   #
########################################################
echo "Nextstall need to know some things before we can continue with the installation"
echo ""
echo "Which version of Nextcloud would you like to install?"
echo "Nextstall can recommend the following stable releases:"
echo ""
grep -v UNSUPPORTED NCversions.txt
echo ""
echo "ONLY type in the version number, eg: '20.0.4'"
echo ""
read -p "I want version: " ncVersion
echo "You have chosen 'Nextcloud version $ncVersion'"
echo ""
press_any_to_continue

########################################################
#           Nextcloud Installation Directory           #
########################################################
clear
echo "Where do you want to install Nextcloud $ncVersion?"
echo ""
echo "Keep in mind that the default location is '/var/www'"
echo ""
echo "Remember to write the FULL path, eg: '/var/www'"
echo ""
echo "Do NOT write a '/' at the end of the path here"
echo ""
read -p "I want to install Nextcloud $ncVersion in: " ncInstallDir
echo "You have chosen to install Nextcloud $ncVersion in '$ncInstallDir'"
echo ""
press_any_to_continue

########################################################
#               Nextcloud Data Directory               #
########################################################
clear
echo "Where do you want Nextcloud to store user files?"
echo ""
echo "Note that the default directory is $ncInstallDir/nextcloud-data"
echo "although it is recommended to place it outside of $ncInstallDir"
echo ""
echo "It is usually OK to place it in $ncInstallDir regardless"
echo ""
echo "Remember to write the FULL path, eg: '$ncInstallDir/nextcloud-data'"
read -p "I want to place Nextcloud data in: " ncDataDir
echo "You have chosen '$ncDataDir' as the data directory"
echo ""
press_any_to_continue

########################################################
#               Nextcloud Database Name                #
########################################################
clear
echo "Nextstall will set up a MariaDB database on your server"
echo ""
echo "What should the database name be called?"
echo "The default is 'nextcloud'"
echo ""
read -p "I want to name the database: " ncDatabaseName
echo "You have chosen '$ncDatabaseName' as Nextclouds database name"
echo ""
press_any_to_continue

########################################################
#             Nextcloud Database Username              #
########################################################
clear
echo "What do you want to name Nextclouds database user?"
echo ""
echo "The default is 'nextcloud'"
echo ""
read -p "I want to name the database user: " ncDatabaseUser
echo "You have chosen '$ncDatabaseUser' as Nextclouds database user"
echo ""
press_any_to_continue

########################################################
#             Nextcloud Database Password              #
########################################################
clear
echo "Which password do you want the database user $ncDatabaseUser to use?"
echo ""
echo "Nextstall suggests you using a rather strong password here"
echo "Please note that the password will be displayed in the installation summary"
echo ""
read -p "I want the database user $ncDatabaseUser to use this password: " ncDatabasePassword
echo "You have chosen '$ncDatabasePassword' as the database password"
echo ""
press_any_to_continue

########################################################
#                   Nextcloud Domain                   #
########################################################
clear
echo "Which domain should the server use for Nextcloud?"
echo ""
echo "Note that Nextcloud is optimized for ONE domain"
echo ""
echo "Domain sample:    mydomain.com"
echo "Subdomain sample: cloud.mydomain.com"
echo ""
echo "If you do not have a domain, set this to 'localhost'"
echo ""
read -p "I want Nextcloud to use the domain: " ncDomain
echo "You have chosen '$ncDomain' as the domain name for Nextcloud"
echo ""
press_any_to_continue

########################################################
#                   Webmaster Email                    #
########################################################
clear
echo "What is the email adress of this servers webmaster?"
echo ""
echo "Nextstall needs this solely for HTTPS certification purposes"
echo ""
echo "If you are unsure, just write in your own email."
echo "Industry standard webmaster emails are 'webmaster@mydomain.com'"
echo ""
read -p "The webmaster email adress is: " ncWebmasterEmail
echo "You have chosen '$ncWebmasterEmail' as the webmaster email"
echo ""
press_any_to_continue

########################################################
#   Does the user want to change advanced settings?    #
########################################################
clear
echo "Nextstall has now gathered all the basic information it needs"
echo ""
echo "Do you want to change more advanced settings?"
echo "Recommended only for experienced users"
echo "Feel free to skip this if you just want to install Nextcloud $ncVersion"
echo ""
echo "If you do choose to change advanced settings, you'll be asked some more questions"
echo ""
echo "Accepted responses are ..."
echo "[$yes] = Yes"
echo "    You will be guided through the advanced settings"
echo ""
echo "[$no] = No"
echo "    We'll start the installation of Nextcloud $ncVersion"
echo ""
read -n 1 choice
echo ""
if [ $choice -eq $yes ]; then
	echo "Sorry, the advanced settings aren't implemented yet ..."
	echo ""
	echo "Continuing with basic settings"
	echo ""
	press_any_to_continue
elif [ $choice -eq $no ]; then
	echo "Ok, we'll start the installation of Nextcloud $ncVersion now"
	press_any_to_continue
else
	echo ""
	echo "Your answer was invalid ..."
	echo "Valid responses are '$yes' yes, and '$no' no"
	echo ""
	echo "We'll just go on with the basic settings"
	sleep 5
	press_any_to_continue
fi

########################################################
#         Information about the summary screen         #
########################################################
clear
echo "The following screen is a summary of the settings you have inputted"
echo ""
echo "Please go over these and make sure they are correct before proceeding"
echo ""
echo "If something is wrong, please abort Nextstall and re-run it"
echo ""
echo ""
echo "To abort Nextstall, press 'CTRL + C'"
echo ""
echo ""
echo ""
echo "If the settings look good, press the 'ENTER' key to continue"
echo ""
read -p "Press any key to view the summary" -n 1 i
i=-1

########################################################
#              Nextstall settings summary              #
########################################################
clear
echo "You are using Nextstall version $version"
echo ""
echo "          Nextstall installation summary"
echo " ---------------------------------------------------"
echo "| Nextcloud version: - - - - -	$ncVersion"
echo "|---------------------------------------------------"
echo "| Installation directory: - - -	$ncInstallDir"
echo "| Data directory: - - - - - - -	$ncDataDir"
echo "|---------------------------------------------------"
echo "| Database name:  - - - - - - -	$ncDatabaseName"
echo "| Database user:  - - - - - - -	$ncDatabaseUser"
echo "| Database password:  - - - - -	$ncDatabasePassword"
echo "|---------------------------------------------------"
echo "| Domain: - - - - - - - - - - -	$ncDomain"
echo "| Webmaster email:  - - - - - -	$ncWebmasterEmail"
echo " --------------------------------------------------- "
echo ""
echo "Make sure all paths begin with a '/'"
echo ""
echo " ------------------------------------------------------------------------------ "
echo "| Nextstall will install the following packages:"
echo "|------------------------------------------------------------------------------ "
echo "| Dependancies: ${installDeps[@]}"
echo "|------------------------------------------------------------------------------ "
echo "| Software: ${installSoft[@]}"
echo "|------------------------------------------------------------------------------ "
echo "| Modules: ${installMods[@]}"
echo " ------------------------------------------------------------------------------ "
echo ""
echo "Make sure the information above is correct BEFORE continuing"
read -p "Press 'ENTER' to continue the installation" i

########################################################
#          End of user settings for Nextstall          #
########################################################

clear
echo ""
echo "This is your last input before changes are made"
echo "If you have any doubts, abort now with 'CTRL + C'"
echo ""
echo "No changes has been made to your system yet"
echo "Nextstall will display the installation summary"
echo "at the end of the installation"
echo ""
read -p "Press the 'ENTER' key to continue" i
i=-1

clear
display_version_warning

########################################################
#               Installing dependancies                #
########################################################
clear
sudo apt update && sudo apt install $installAll -y && wait

cd $initDir
mkdir $nctemp
echo ""
echo "-| Nextstall |- Created the folder '$nctemp'"
echo "-| Nextstall |- Now downloading Nextcloud $ncVersion from $ncDownloadURL"
cd $nctemp && wget $ncDownloadURL
echo ""
echo "-| Nextstall |- Nextcloud version $ncVersion has been downloaded"
echo ""
echo "-| Nextstall |- Placing Nextcloud in $ncInstallDir"
echo "-| Nextstall |- Generating a backup of $ncInstallDir if it already exists"
mv $ncInstallDir $ncInstallDir.backup && wait
mkdir $ncInstallDir && wait
mkdir nextcloud
unzip nextcloud-$ncVersion.zip && wait
mv nextcloud/* $ncInstallDir && wait
cd $initDir && mkdir oldZips && mv $nctemp/*.zip oldZips/
rm -r $nctemp && wait
echo ""
echo "-| Nextstall |- Nextcloud has been installed in $ncInstallDir"
echo "-| Nextstall |- Now proceeding with configurations"
echo ""
sudo systemctl start apache2 && sudo systemctl enable apache2
sudo a2enmod php7.4 && sudo systemctl restart apache2
echo ""
echo "-| Nextstall |- The following PHP version is now installed:"
php --version
echo ""
echo "-| Nextstall |- Opening port 80 and 443 for network traffic"
sudo ufw allow 80 443 && wait
echo ""
echo "-| Nextstall |- Giving Apache2 permissions for Nextcloud"
sudo chown www-data:www-data $ncInstallDir -R
sudo chown www-data:www-data $ncDataDir -R
echo ""
echo "-| Nextstall |- Starting the configuration of MariaDB"
sudo systemctl start mariadb && sudo systemctl enable mariadb
echo ""
echo "-| Nextstall |- Confirm that Apache2 and MariaDB are both running"
echo "-| Nextstall |- They should both say 'active'"
systemctl status apache2 | grep active
systemctl status mariadb | grep active
echo ""
echo "You're all good if they both say 'active'"
echo ""
echo "When you are ready, you'll be taken to the guided installation"
echo "of MariaDB. Here are some tips if you are unsure about it:"
echo ""
echo "On the second question during the install, you'll be asked to set a password"
echo "Make sure this is a secure password, and write it down"
echo "Nextstall DOES NOT SAVE THAT PASSWORD, so write it down somewhere safe"
echo ""
echo "Simply press 'ENTER' on any other questions during the MariaDB installation"
echo ""
read -p "Press the 'ENTER' key to continue" i
i=-1

clear
echo "Starting the installation of MariaDB"
echo "Remember: secure password on question 2, 'ENTER' on any other questions"
echo ""
echo "NOTE: If you have an existing MariaDB install, you need to input this"
echo "in the corresponding dialogue input"
echo ""
echo "Feel free to customize it to your liking if you know what you are doing"
echo " --------------------------------------------------------------------- "
sleep 2
sudo mysql_secure_installation



echo "You've reached the end of the script" && sleep 3
exit 1	# EOF. Everything under this line is residual code from earlier versions

###################################################################



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
