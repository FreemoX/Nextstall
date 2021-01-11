# Nextstall
*Version: 0.0.1*
| *Date:	11 jan 2021* | 
**NOT FOR USE UNTIL V 0.1.0**
*Production-ready at version 1.0.0*

*Dialogue languages: Norwegian*
 | *English coming soon*

*Nextstall is a Linux script meant to simplify the installation of Nextcloud on your servers. The script walks you through the entire installation procedure, allowing you to install a working Nextcloud instance on a fresh Linux distro in a matter of minutes.*

Nextstall is written by Franz Rolfsvaag, and released under the GNU GPL V3 license. 
You are free to make changes to this script and to use it in your own projects, both for commercial and non-commercial use. 

# Installation instructions
***NOTE:** These instructions are tested in Ubuntu 20.4. Make sure to do corresponding changes depending on your Linux distro!*
 1. **Update your OS install**
> sudo apt update && sudo apt upgrade -y
 2. **Install Git**
 > sudo apt install git
 3. **Clone the Nextstall GitHub repository**
> git clone https://github.com/FreemoX/Nextstall.git
 4. **Navigate to the Nextstall directory**
> cd Nextstall
 5. **Make the Nextstall script an executable**
> sudo chmod +x Nextstall.sh

*Note: The script will automatically install everything needed for Nextcloud*
# How to use
*Note: Nextstall is very user-friendly, and will guide you through the entire installation process.*

 1. **Navigate to the Nextstall directory if you have not already done so**
The default directory is home/Nextstall
> cd && cd Nextstall
 2. **Run Nextstall as sudo**
*NOTE: Nextstall need sudo permissions in order to perform changes in system folders such as /var/www and in the database. Remember that you can review the script code yourself if you feel uneasy about giving Nextstall sudo permissions. The script file can be found here -> https://github.com/FreemoX/Nextstall/blob/main/Nextstall.sh*
> sudo ./Nextstall.sh
 3. **Follow on-screen instructions**

