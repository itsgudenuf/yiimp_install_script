# Yiimp_install_scrypt v0.2 (update September, 2022)

Original SCRIPT : https://github.com/cryptopool-builders/multipool_original_yiimp_installer  
Improved SCRIPT : https://github.com/vaudois/yiimp_install_scrypt


***********************************

## Install script for yiimp on Ubuntu Server 18.04  (No Longer Supporting 16.04)  
* hope to update to 20.04 LTS when I have time

USE THIS SCRIPT ON FRESH INSTALL UBUNTU Server 18.04 Only!

Connect on your VPS/VM/Server =>
- adduser pool
- adduser pool sudo
- su - pool
- sudo apt -y install git
- git clone https://github.com/itsgudenuf/yiimp_install_script.git
- cd yiimp_install_script/
- bash install.sh (DO NOT RUN THE SCRIPT AS ROOT or SUDO)
- At the end, you MUST REBOOT to finalize installation...

Finish !
Go http://xxx.xxx.xxx.xxx or https://xxx.xxx.xxx.xxx (if you have chosen LetsEncrypt SSL). Enjoy !

###### :bangbang: **YOU MUST UPDATE THE FOLLOWING FILES :**
- **/var/web/serverconfig.php :** update this file to include your public ip (line = YAAMP_ADMIN_IP) to access the admin panel (Put your PERSONNAL IP, NOT IP of your VPS). update with public keys from exchanges. update with other information specific to your server..
- **/etc/yiimp/keys.php :** update with secrect keys from the exchanges (not mandatory)


###### :bangbang: **IMPORTANT** : 

- The configuration of yiimp and coin require a minimum of knowledge in linux
- Your mysql information (login/Password) is saved in **~/.my.cnf**

***********************************

###### This script has an interactive beginning and will ask for the following information :

- Server Name 
- Are you using a subdomain
- Enter support email
- Set stratum to AutoExchange
- Select Yimmp install
- Your Public IP for admin access (Put your PERSONNAL IP, NOT IP of your VPS, Or your LAN if running the server locally)
- Install Fail2ban
- Install UFW and configure ports
- Install LetsEncrypt SSL  -- This is untested (I plan to implement certbot w/ support for Cloudflare-dns as that's what I use)

***********************************

**This install script will get you 90% ready to go with yiimp. There are a few things you need to do after the main install is finished.**

It is every server owners responsibility to fully secure their own servers. After the installation you will still need to customize your serverconfig.php file to your liking, add your API keys, and build/add your coins to the control panel. 

Adding the Coins and connecting to the nodes for those blockchains caused me the greatest headache.

There will be several wallets already in yiimp. These have nothing to do with the installation script and are from the database import from the yiimp github. 
You should change any Wallet address you don't recognize.... unless you want to send me some coin :)


If this helped you or you feel like giving please donate to : 
- BTC Donation : bc1qp0m22e70d7qv9kdxd8kyw7xy47mk8gq3r4xy7v
- ETC Donation : 0xF875c07653Dfba3CcE42d4C9D948f5f1DA23B3d7 
