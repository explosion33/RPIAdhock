# RPIAdhock
setup to create an adhock network hosted on a raspberrypi 4B

## Pre Setup
### connect to rpi and connect to network

need an ssh/vlc/monitor connection

need internet access, this can be through ethernet direct

sharing via windows network connection center

or connection to wifi network

### other

must set the wifi region on rpi

```
sudo raspi-config
```

> localization Options

> WLAN Config

## Auto Setup

load files onto RPI
run ```sudo bash wlansetup.sh``` follow prompts

## Manual Setup

Run ```sudo apt install dnsmasq hostapd```

then

```
sudo systemctl stop dnsmasq
sudo systemctl stop hostapd
```

open ```sudo nano /etc/dhcpcd.conf```

at the bottom enter

```
interface wlan0
    static ip_address=192.168.4.1/24
    nohook wpa_supplicant
```

save and then type

```
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
```

open ```sudo nano /etc/dnsmasq.conf```

then type

```
interface=wlan0      # Use the require wireless interface - usually wlan0
dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h
```

start the dnsmasq ```sudo systemctl start dnsmasq```

configure access point

open ```sudo nano /etc/hostapd/hostapd.conf```

enter and change ssid, and password

```
interface=wlan0
driver=nl80211
ssid=NameOfNetwork
hw_mode=g
channel=7
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=8CHARPASSPHRASE
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
```

any wrong typing here will cause the WAN to fail

enter ```sudo nano /etc/default/hostapd```

find the line ```#DAEMON_CONF``` and replace it with ```DAEMON_CONF="/etc/hostapd/hostapd.conf"```

start hostapd

```
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl start hostapd
```

open the wifi browser and ensure you can connect to the network
You will now also be able to SSH into the machine again

Steps adapted from [this](https://www.raspberrypi.org/documentation/configuration/wireless/access-point.md) guide
