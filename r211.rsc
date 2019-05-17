# jan/06/1980 02:51:29 by RouterOS 6.44.2
# software id = 3Z3Q-9R7G
#
# model = RB912R-2nD
# serial number = 991309616346
/interface lte
set [ find ] mac-address=AC:FF:FF:00:00:00 mtu=1500 name=lte1
/interface bridge
add name=br-v211
add admin-mac=B8:69:F4:BA:F5:99 auto-mac=no comment=defconf name=bridge
add name=bridge-lte
/interface pptp-client
add connect-to=193.43.95.6 disabled=no name=pptp-out1 password=railroad2019 \
    user=railroad-life
/interface eoip
add mac-address=02:A1:54:26:F1:5D name=eoip-uman-mng remote-address=\
    172.21.56.1 tunnel-id=211
/interface vlan
add interface=ether1 name=v2_eth1 vlan-id=2
add interface=ether1 name=v10_eth1 vlan-id=10
add interface=ether1 name=v70_eth1 vlan-id=70
add interface=ether1 name=v211_eth1 vlan-id=211
/interface list
add comment=defconf name=WAN
add comment=defconf name=LAN
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
add authentication-types=wpa-psk,wpa2-psk management-protection=allowed mode=\
    dynamic-keys name=profile-12345 supplicant-identity=MikroTik \
    wpa-pre-shared-key=1234554321 wpa2-pre-shared-key=1234554321
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-b/g/n channel-width=20/40mhz-Ce \
    country=ukraine distance=indoors mode=ap-bridge security-profile=\
    profile-12345 ssid=346 wireless-protocol=802.11 wps-mode=disabled
/ip hotspot profile
set [ find default=yes ] html-directory=flash/hotspot
/ip pool
add name=default-dhcp ranges=192.168.88.10-192.168.88.254
/ip dhcp-server
add address-pool=default-dhcp disabled=no interface=bridge name=defconf
/interface bridge port
add bridge=bridge comment=defconf disabled=yes interface=ether1
add bridge=bridge comment=defconf interface=wlan1
add bridge=br-v211 interface=eoip-uman-mng
add bridge=br-v211 interface=v211_eth1
add bridge=bridge-lte disabled=yes interface=dynamic
/ip neighbor discovery-settings
set discover-interface-list=all
/interface list member
add comment=defconf interface=bridge list=LAN
add comment=defconf interface=lte1 list=WAN
/ip address
add address=192.168.88.1/24 comment=defconf interface=bridge network=\
    192.168.88.0
add address=10.10.11.1/24 interface=v10_eth1 network=10.10.11.0
add address=172.21.70.11/24 interface=v70_eth1 network=172.21.70.0
add address=192.168.212.3/24 interface=br-v211 network=192.168.212.0
/ip dhcp-client
add add-default-route=no dhcp-options=hostname,clientid disabled=no \
    interface=v2_eth1 use-peer-dns=no
/ip dhcp-server network
add address=192.168.88.0/24 comment=defconf gateway=192.168.88.1
/ip dns
set allow-remote-requests=yes
/ip dns static
add address=192.168.88.1 name=router.lan
/ip firewall filter
add action=accept chain=input comment=\
    "defconf: accept established,related,untracked" connection-state=\
    established,related,untracked disabled=yes
add action=drop chain=input comment="defconf: drop invalid" connection-state=\
    invalid disabled=yes
add action=accept chain=input comment="defconf: accept ICMP" disabled=yes \
    protocol=icmp
add action=drop chain=input comment="defconf: drop all not coming from LAN" \
    disabled=yes in-interface-list=!LAN
add action=accept chain=forward comment="defconf: accept in ipsec policy" \
    disabled=yes ipsec-policy=in,ipsec
add action=accept chain=forward comment="defconf: accept out ipsec policy" \
    disabled=yes ipsec-policy=out,ipsec
add action=fasttrack-connection chain=forward comment="defconf: fasttrack" \
    connection-state=established,related disabled=yes
add action=accept chain=forward comment=\
    "defconf: accept established,related, untracked" connection-state=\
    established,related,untracked disabled=yes
add action=drop chain=forward comment="defconf: drop invalid" \
    connection-state=invalid disabled=yes
add action=drop chain=forward comment=\
    "defconf:  drop all from WAN not DSTNATed" connection-nat-state=!dstnat \
    connection-state=new disabled=yes in-interface-list=WAN
/ip firewall nat
add action=masquerade chain=srcnat comment="defconf: masquerade" \
    ipsec-policy=out,none out-interface-list=WAN
/ip route
add distance=1 dst-address=172.20.1.30/32 gateway=172.21.70.1
add distance=1 dst-address=172.21.0.0/16 gateway=172.21.70.1
/ip ssh
set allow-none-crypto=yes
/port remote-access
add disabled=yes port=serial0
/snmp
set enabled=yes
/system clock
set time-zone-name=Europe/Kiev
/system console
set [ find ] disabled=yes
/system gps
set enabled=yes port=serial0 set-system-time=yes
/system identity
set name="ltAP-11.1 (Life/Intertelecom)"
/system logging
add disabled=yes topics=lte,!raw
/system routerboard sim
set sim-slot=up
/system scheduler
add interval=1m name=send_lte_data on-event=send_lte_data policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
add interval=30m name=modem_hang on-event=check_for_hang policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
/system script
add dont-require-permissions=no name=send_lte_data owner=taras policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":\
    local info [/interface lte info lte1 once as-value]\r\
    \n\r\
    \n:local at (\$info->\"access-technology\")\r\
    \n:local operator (\$info->\"current-operator\")\r\
    \n:local rssi (\$info->\"rssi\")\r\
    \n:local signal\r\
    \n:local lac (\$info->\"lac\")\r\
    \n:local cid (\$info->\"current-cellid\");\r\
    \n\r\
    \n:if (\$rssi = nil) do={\r\
    \n\r\
    \n\t\t\t\t:set signal (\$info->\"rsrp\")\r\
    \n\r\
    \n\t\t\t} else={\r\
    \n\r\
    \n\t\t\t\t:set signal (\$info->\"rssi\")\r\
    \n\r\
    \n\t\t\t}\r\
    \n\r\
    \n:set operator \"Life\";\r\
    \n:log info \$at\r\
    \n:log info \$operator\r\
    \n:log info \$signal\r\
    \n:log info \$cid\r\
    \n:log info \$lac\r\
    \n\r\
    \ntool fetch mode=http url=\"http://inwhite.com.ua/matrisa.php\" port=80 h\
    ttp-method=post http-data=(\"{\\\"lac\\\":\\\"\" . \$lac . \"\\\",\\\"cid\
    \\\":\\\"\" . \$cid . \"\\\",\\\"at\\\":\\\"\" . \$at . \"\\\",\\\"operato\
    r\\\":\\\"\" . \$operator . \"\\\", \\\"signal\\\":\\\"\" . \$signal . \"\
    \\\"}\") http-header-field=\"Content-Type: application/json\" \r\
    \n\r\
    \n:put (\"{\\\"lac\\\":\\\"\" . \$lac . \"\\\",\\\"cid\\\":\\\"\" . \$cid \
    . \"\\\",\\\"at\\\":\\\"\" . \$at . \"\\\",\\\"operator\\\":\\\"\" . \$ope\
    rator . \"\\\", \\\"signal\\\":\\\"\" . \$signal . \"\\\"}\")\r\
    \n\r\
    \n}\r\
    \n\r\
    \n"
add dont-require-permissions=no name=check_for_hang owner=railroad policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":\
    if ( [/ping 8.8.8.8 count=10 size=64 interval=2s ] =0) do={\r\
    \n:log error \"-----No ping\";\r\
    \n/system routerboard usb power-reset duration=10;\r\
    \n:log error \"----Reset USB Power\";\r\
    \n} else={\r\
    \n:log info \"-----LTE OK-----\";\r\
    \n}"
/tool mac-server
set allowed-interface-list=LAN
/tool mac-server mac-winbox
set allowed-interface-list=LAN
/tool netwatch
add down-script="/interface lte disable 0 \r\
    \n/interface lte enable 0" host=8.8.8.8 interval=15m timeout=30s
/tool sms
set port=lte1 receive-enabled=yes
