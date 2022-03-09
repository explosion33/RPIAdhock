apt install dnsmasq hostapd
sudo systemctl stop dnsmasq
sudo systemctl stop hostapd

sudo touch /etc/dhcpcd.conf

echo "interface wlan0"                      | sudo tee -a /etc/dhcpcd.conf
echo "    static ip_address=192.168.4.1/24" | sudo tee -a /etc/dhcpcd.conf
echo "    nohook wpa_supplicant"            | sudo tee -a /etc/dhcpcd.conf

sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig

sudo touch /etc/dnsmasq.conf

sudo echo "interface=wlan0"                                       >> /etc/dnsmasq.conf
sudo echo "dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h" >> /etc/dnsmasq.conf

sudo systemctl start dnsmasq

sudo touch /etc/hostapd/hostapd.conf

read -p "Enter Network Name: " netname
read -p "Enter Passphrase (>8 characters): " psk

sudo echo "interface=wlan0"          >> /etc/hostapd/hostapd.conf
sudo echo "driver=nl80211"           >> /etc/hostapd/hostapd.conf
sudo echo "ssid=$netname"            >> /etc/hostapd/hostapd.conf
sudo echo "hw_mode=g"                >> /etc/hostapd/hostapd.conf
sudo echo "channel=7"                >> /etc/hostapd/hostapd.conf
sudo echo "wmm_enabled=0"            >> /etc/hostapd/hostapd.conf
sudo echo "macaddr_acl=0"            >> /etc/hostapd/hostapd.conf
sudo echo "auth_algs=1"              >> /etc/hostapd/hostapd.conf
sudo echo "ignore_broadcast_ssid=0"  >> /etc/hostapd/hostapd.conf
sudo echo "wpa=2"                    >> /etc/hostapd/hostapd.conf
sudo echo "wpa_passphrase=$psk"      >> /etc/hostapd/hostapd.conf
sudo echo "wpa_key_mgmt=WPA-PSK"     >> /etc/hostapd/hostapd.conf
sudo echo "wpa_pairwise=TKIP"        >> /etc/hostapd/hostapd.conf
sudo echo "rsn_pairwise=CCMP"        >> /etc/hostapd/hostapd.conf

echo "DAEMON_CONF=\"/etc/hostapd/hostapd.conf\"" | sudo tee -a /etc/default/hostapd 

sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl start hostapd