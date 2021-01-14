# Nextstall
*Version: 0.0.3*
| *Date:	14 jan 2021* | 
**NOT FOR USE UNTIL V 0.1.0**
*Production-ready at version 1.0.0*

*Dialogue languages: English
     Multilanguage planned*

*Nextstall is a Linux script meant to simplify the installation of Nextcloud on your servers. The script walks you through the entire installation procedure, allowing you to install a working Nextcloud instance on a fresh Linux distro in a matter of minutes.*

Nextstall is written by Franz Rolfsvaag, and released under the GNU GPL V3 license. 
You are free to make changes to this script and to use it in your own projects, both for commercial and non-commercial use. 

# Important information
Nextstall is provided free of charge, but its usage is at your own risk. We're working on making sure Nextstall is a safe to run as possible, but things can go awry.
Nextstall is currently only intended to be used on fresh OS installs. Its usage on established systems is not recommended, and may have adverse effects even if used correctly.
There are **no** safety features currently implemented in Nextstall. Make sure you know what you are doing if you do not follow the default or recommended settings.
Nextstall is only tested on a select few Linux distros. We can not ensure its functionality outside these distros, but as long as you do the appropriate changes depending on your OS, it should still work as long as you can run *bash* scripts. The currently tested Linux distros are:
Ubuntu 20.04

# Installation instructions
***NOTE:** These instructions are tested in Ubuntu 20.04. Make sure to do corresponding changes depending on your Linux distro!*
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
> cd ~/Nextstall
 2. **Make the Nextstall script executable**
> sudo chmod +x Nextstall.sh
 3. **Run Nextstall as sudo**
*NOTE: Nextstall need sudo permissions in order to perform changes in system folders such as /var/www and in the database. Remember that you can review the script code yourself if you feel uneasy about giving Nextstall sudo permissions. The script file can be found here -> https://github.com/FreemoX/Nextstall/blob/main/Nextstall.sh*
> sudo ./Nextstall.sh
 4. **Follow on-screen instructions**
 
# Roadmap
 1. Ensure Nextstall can complete a full Nextcloud install
 2. Make Nextstall user-friendly enough for anyone to use it
 3. Implement multi-language capabilities in Nextstall
 4. Optimalize the code
