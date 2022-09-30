#!/bin/bash
################################################################################
# Original Author:   crombiecrunch
# Fork Author: manfromafar
# Current Author: itsgudenuf
# Web:     
#
# Program:
#   Install yiimp stratum and blocknotify
#   refining to work the way I run my pool. YMMV
# 
################################################################################

### Variable ###
githubrepoKudaraidee=https://github.com/Kudaraidee/yiimp.git
githubyiimptpruvot=https://github.com/tpruvot/yiimp.git
githubrepoAfinielTech=https://github.com/Afiniel-tech/yiimp.git
githubrepoAfiniel=https://github.com/afiniel/yiimp

function output() {
    printf "\E[0;33;40m"
    echo $1
    printf "\E[0m"
}

function displayErr() {
    echo
    echo $1;
    echo
    exit 1;
}

function spinner {
 		local pid=$!
 		local delay=0.75
 		local spinstr='|/-\'
 		while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
 				local temp=${spinstr#?}
 				printf " [%c]  " "$spinstr"
 				local spinstr=$temp${spinstr%"$temp"}
 				sleep $delay
 				printf "\b\b\b\b\b\b"
 		done
 		printf "    \b\b\b\b"
 }


function hide_output {
		OUTPUT=$(mktemp)
		$@ &> $OUTPUT & spinner
		E=$?
		if [ $E != 0 ]; then
            echo
            echo FAILED: $@
            echo -----------------------------------------
            cat $OUTPUT
            echo -----------------------------------------
            exit $E
		fi

		rm -f $OUTPUT
}


#Add user group sudo + no password
whoami=`whoami`
sudo usermod -aG sudo ${whoami}
echo '# yiimp
# It needs passwordless sudo functionality.
'""''"${whoami}"''""' ALL=(ALL) NOPASSWD:ALL
' | sudo -E tee /etc/sudoers.d/${whoami} >/dev/null 2>&1

# import REMOTE_stratum.conf and skip all the questions
if [ -f "./REMOTE_stratum.conf" ]; then
    source ./REMOTE_stratum.conf
    echo " "
    echo "REMOTE Stratum config has been imported"
    echo " "
else
    output " "
    output "Make sure you double check before hitting enter! Only one shot at these!"
    output " "
    read -e -p "Enter desired Yiimp GitHub (1=Kudaraidee or 2=tpruvot or 3=Afiniel-Tech 4= Afiniel) [1 by default] : " yiimpver
    read -e -p "Enter your block notify password  (required) : " blckntifypass
    read -e -p "This Server's name (no http:// just stratum-us.example.com) : " server_name
    read -e -p "Set stratum to AutoExchange? i.e. mine any coin with BTC address? [y/N] : " BTC
    read -e -p "Enter the Pool's sql server ip address : " MYSQLIP
    read -e -p "Enter the Pool's sql server database : " MYSQLDB
    read -e -p "Enter the Pool's sql stratum username : " MYSQLUSER
    read -e -p "Enter the Pool's sql stratum password : " MYSQLPASS
    read -e -p "Enter Public IP of the sql server (for VPN) : " VPNSERVER
    read -e -p "Enter private vpn IP for this server (must be in same net as $MYSQLIP/24) : " VPNIP 
fi
    
    output " "
    output "Updating system and installing required packages."
    output " "
    sleep 3
    
    
    # update package and upgrade Ubuntu
    hide_output sudo apt -y update 
    hide_output sudo apt -y upgrade
    hide_output sudo apt -y autoremove


    hide_output sudo apt install -y software-properties-common
    # hide_output sudo add-apt-repository ppa:wireguard/wireguard -y
    hide_output sudo apt update -y
    hide_output sudo apt install wireguard-dkms wireguard-tools -y

    (umask 077 && printf "[Interface]\nPrivateKey = " | sudo tee /etc/wireguard/wg0.conf > /dev/null)
    wg genkey | sudo tee -a /etc/wireguard/wg0.conf | wg pubkey | sudo tee /etc/wireguard/publickey
    sudo sed -i '$aAddress = '$VPNIP'/32\nListenPort = 6121\n\n' /etc/wireguard/wg0.conf
    sudo sed -i '$a [Peer]\nPublicKey = '$VPNPUBBKEY' \nAllowedIPs = '$MYSQLIP'/24\nEndpoint='$VPNSERVER':6121\n' /etc/wireguard/wg0.conf

    sudo systemctl start wg-quick@wg0
    sudo systemctl enable wg-quick@wg0
    sudo ufw allow 6121


    # install mariadb repo so we are building off the same client as the server
    sudo apt install apt-transport-https curl -y
    sudo curl -o /etc/apt/trusted.gpg.d/mariadb_release_signing_key.asc 'https://mariadb.org/mariadb_release_signing_key.asc'
    sudo sh -c "echo 'deb https://atl.mirrors.knownhost.com/mariadb/repo/10.4/ubuntu bionic main' >> /etc/apt/sources.list.d/mariadb.list"

    sudo apt update -y


    #Installing Package to compile crypto currency
    output " "
    output "Installing Packages to compile things"
    output " "
    sleep 3
    
    PACKAGES="s-nail screen git net-tools 
            htop pwgen 
            make 
            libgmp3-dev 
            build-essential 
            libmysqlclient-dev 
            libtool 
            libcurl4-gnutls-dev 
            automake 
            libkrb5-dev 
            gnutls-dev 
            libidn11-dev 
            libldap2-dev 
            librtmp-dev 
            libnghttp2-dev 
            libpsl-dev 
            autotools-dev 
            pkg-config 
            libssl-dev 
            libevent-dev 
            bsdmainutils 
            libboost-all-dev 
            zlib1g-dev 
            libzmq5 
            libzmq3-dev 
            mariadb-client 
        "
            
        # Not yet needed
            # cmake 
            # libz-dev 
            # libseccomp-dev 
            # libcap-dev 
            # libminiupnpc-dev 
            # libminiupnpc10 
            # libcanberra-gtk-module 
            # libqrencode-dev 
            # libqt5gui5 
            # libqt5core5a 
            # libqt5webkit5-dev 
            # libqt5dbus5 
            # qttools5-dev 
            # qttools5-dev-tools 
            # libprotobuf-dev 
            # protobuf-compiler 
    

    sudo apt install -y $PACKAGES


#    sudo add-apt-repository -y ppa:bitcoin/bitcoin
#    sudo apt -y update
#    sudo apt install -y libdb4.8-dev libdb4.8++-dev libdb5.3 libdb5.3++
	
    output " "
    output " "
    output " "
    output "Grabbing yiimp fron Github, building files and setting file structure."
    output " "
    sleep 3

    cd ~

    if [[ ("$yiimpver" == "1" || "$yiimpver" == "") ]];then
		cd ~
		hide_output git clone $githubrepoKudaraidee
    elif [[ "$yiimpver" == "2" ]]; then
		cd ~
		hide_output git clone $githubyiimptpruvot
		cd ~
	elif [[ "$yiimpver" == "3" ]]; then
		cd ~
		hide_output git clone $githubrepoAfinielTech
	elif [[ "$yiimpver" == "3" ]]; then
		cd ~
		hide_output git clone $githubrepoAfiniel -b next
    else
        echo "OOOOPS!!!! I should not be here. Exiting...."
        exit
	fi

    cd $HOME/yiimp/blocknotify
    sudo sed -i 's/tu8tu5/'$blckntifypass'/' blocknotify.cpp
    sudo make
    cd $HOME/yiimp/stratum/iniparser
    sudo make
    cd $HOME/yiimp/stratum
    if [[ ("$BTC" == "y" || "$BTC" == "Y") ]]; then
        sudo sed -i 's/CFLAGS += -DNO_EXCHANGE/#CFLAGS += -DNO_EXCHANGE/' $HOME/yiimp/stratum/Makefile
    fi
    sudo make
    cd $HOME/yiimp
    sudo mkdir -p /var/stratum
    cd $HOME/yiimp/stratum
    sudo cp -a config.sample/. /var/stratum/config
    sudo cp -r stratum /var/stratum
    sudo cp -r run.sh /var/stratum
    cd $HOME/yiimp
    sudo cp -r $HOME/yiimp/bin/. /bin/
    sudo cp -r $HOME/yiimp/blocknotify/blocknotify /usr/bin/
    sudo cp -r $HOME/yiimp/blocknotify/blocknotify /var/stratum/
    # sudo mkdir -p /etc/yiimp
    sudo mkdir -p $HOME/backup/
    #fixing yiimp
    # sed -i "s|ROOTDIR=/data/yiimp|ROOTDIR=/var|g" /bin/yiimp
    #fixing run.sh
    sudo rm -r /var/stratum/config/run.sh
	echo '
#!/bin/bash
ulimit -n 10240
ulimit -u 10240
cd /var/stratum
while true; do
        ./stratum /var/stratum/config/$1
        sleep 2
done
exec bash
' | sudo -E tee /var/stratum/config/run.sh >/dev/null 2>&1
sudo chmod +x /var/stratum/config/run.sh


    output " "
    output "Setting TimeZone to UTC..."
    output " "

    if [ ! -f /etc/timezone ]; then
        echo "Setting timezone to UTC."
        echo "Etc/UTC" > sudo /etc/timezone
        sudo systemctl restart rsyslog
    fi
    sudo systemctl status rsyslog | sed -n "1,3p"
    output " "
    output "   Done!"
    output " "

    
    # # check if link file
    # sudo [ -L /etc/localtime ] &&  sudo unlink /etc/localtime
    
    # # update time zone
    # sudo ln -sf /usr/share/zoneinfo/$TIME /etc/localtime
    # sudo apt -y install ntpdate
    
    # # write time to clock.
    # sudo hwclock -w

output " "
output "Updating stratum config files with database connection info."
output " "
sleep 3

cd /var/stratum/config
sudo sed -i 's/password = tu8tu5/password = '$blckntifypass'/g' *.conf
sudo sed -i 's/server = yaamp.com/server = '$server_name'/g' *.conf
sudo sed -i 's/host = yaampdb/host = '$MYSQLIP'/g' *.conf
sudo sed -i 's/database = yaamp/database = '$MYSQLDB'/g' *.conf
sudo sed -i 's/username = root/username = '$MYSQLUSER'/g' *.conf
sudo sed -i 's/password = patofpaq/password = '$MYSQLPASS'/g' *.conf
# Add debuglog section options
sudo sed -i '$a[DEBUGLOG]\nclient = 0\nhash = 0\nsocket = 0\nrpc = 0\nlist = 0\nremote = 0' *.conf

cd ~

output " "
output "Final Directory permissions"
output " "
sleep 3

# fix the screenrc file
echo 'deflogin on' | sudo -E tee /etc/screenrc >/dev/null 2>&1
echo 'vbell on' | sudo -E tee -a /etc/screenrc >/dev/null 2>&1
echo 'vbell_msg "   Wuff  ----  Wuff!!  "' | sudo -E tee -a /etc/screenrc >/dev/null 2>&1
echo 'defscrollback 1024' | sudo -E tee -a /etc/screenrc >/dev/null 2>&1
echo 'bind ^k' | sudo -E tee -a /etc/screenrc >/dev/null 2>&1
echo 'bind ^\' | sudo -E tee -a /etc/screenrc >/dev/null 2>&1
echo 'bind \\ quit' | sudo -E tee -a /etc/screenrc >/dev/null 2>&1
echo 'bind K kill' | sudo -E tee -a /etc/screenrc >/dev/null 2>&1
echo 'bind I login on' | sudo -E tee -a /etc/screenrc >/dev/null 2>&1
echo 'bind O login off' | sudo -E tee -a /etc/screenrc >/dev/null 2>&1
echo 'bind } history' | sudo -E tee -a /etc/screenrc >/dev/null 2>&1
echo 'termcapinfo vt100 dl=5\E[M' | sudo -E tee -a /etc/screenrc >/dev/null 2>&1
echo 'hardstatus off' | sudo -E tee -a /etc/screenrc >/dev/null 2>&1
echo 'termcapinfo xterm*|rxvt*|kterm*|Eterm* hs:ts=\E]0;:fs=\007:ds=\E]0;\007' | sudo -E tee -a /etc/screenrc >/dev/null 2>&1
echo 'hardstatus alwayslastline' | sudo -E tee -a /etc/screenrc >/dev/null 2>&1
echo "hardstatus string '%{= kG}[ %{G}%H %{g}][%= %{=kw}%?%-Lw%?%{r}(%{W}%n*%f%t%?(%u)%?%{r})%{w}%?%+Lw%?%?%= %{g}][%{B}%Y-%m-%d %{W}%c %{g}]'" | sudo -E tee -a /etc/screenrc >/dev/null 2>&1
echo 'termcapinfo xterm*|linux*|rxvt*|Eterm* OP' | sudo -E tee -a /etc/screenrc >/dev/null 2>&1
echo "termcapinfo xterm 'is=\E[r\E[m\E[2J\E[H\E[?7h\E[?1;4;6l'" | sudo -E tee -a /etc/screenrc >/dev/null 2>&1
echo 'defnonblock 5' | sudo -E tee -a /etc/screenrc >/dev/null 2>&1


output " "
output "Activating UFW"
sudo apt install ufw -y

hide_output sudo ufw default deny incoming
hide_output sudo ufw default allow outgoing
hide_output sudo ufw allow ssh
hide_output sudo ufw --force enable 
sudo systemctl status ufw | sed -n "1,3p"   

# REmove the OS upgrader
sudo apt purge ubuntu-release-upgrader-core -y 
sudo rm -rf /var/lib/update-notifier
sudo rm -rf /var/lib/ubuntu-release-upgrader


# Clean up some MOTD stuff
sudo rm -f /etc/update-motd.d/10-help-text
sudo rm -f /etc/update-motd.d/50-motd-news
sudo rm -f /etc/update-motd.d/88-esm-announce


# I DO NOT Recommend Vultr servers, they seem to have severe performance issues as well as package issues
# Good luck, if you want to try.
if [ -d "/opt/vultr" ]; then
    # disable the rewrite of /etc/hosts
    sudo sed -i '/update_etc_hosts/d' /etc/cloud/cloud.cfg
    sudo sed -i '/preserve_hostname.* /a manage_etc_hosts: false' /etc/cloud/cloud.cfg

fi


whoami=`whoami`
sudo mkdir /root/backup/
sudo chown -R $whoami. /var/stratum
sudo chmod -R 775 /var/stratum
sudo mv $HOME/yiimp/ $HOME/yiimp-install-only-do-not-run-commands-from-this-folder

echo " "
ip add li | grep -A 2 mtu | grep -v link
echo " "
echo "WG Public key: "
sudo cat /etc/wireguard/publickey
echo " "
echo "Check/Fix your VPN to the Database"
echo " "
echo "add MySQL access for $MYSQLUSER from this host's wg0 IP"
echo "mysql> GRANT ALL PRIVILEGES ON  $MYSQLDB.* to '$MYSQLUSER'@'$VPNIP' IDENTIFIED BY '$MYSQLPASS';"
echo "mysql> flush privileges;"
echo " "
echo "Test your work: echo 'show tables;' | mysql -h $MYSQLIP -u  $MYSQLUSER -p$MYSQLPASS $MYSQLDB"
echo " "
echo " "
echo  "Please make sure to update and launch the stratum screen file(s)."

sleep 3