# may/17/2019 10:17:34 by RouterOS 6.44.2
# software id = SKZD-8G5H
#
# model = RB912R-2nD
# serial number = 991309E14BC4
/interface lte
set [ find ] mac-address=AC:FF:FF:00:00:00 mtu=1500 name=lte1
/interface bridge
add name=br-v210
add admin-mac=B8:69:F4:BA:F5:78 auto-mac=no comment=defconf name=bridge
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-b/g/n distance=indoors frequency=\
    auto mode=ap-bridge ssid=BC4 wireless-protocol=802.11
/interface pptp-client
add connect-to=193.43.95.6 disabled=no name=pptp-out1 password=railroad2019 \
    user=railroad-kv/mts
/interface eoip
add mac-address=02:BF:8A:88:A3:FC name=eoip-mng-uman remote-address=\
    172.21.56.1 tunnel-id=210
/interface vlan
add interface=ether1 name=v2_eth1 vlan-id=2
add interface=ether1 name=v10_eth1 vlan-id=10
add interface=ether1 name=v70_eth1 vlan-id=70
add interface=ether1 name=v210_eth1 vlan-id=210
/interface list
add comment=defconf name=WAN
add comment=defconf name=LAN
/interface wireless security-profiles
set [ find default=yes ] authentication-types=wpa2-psk eap-methods="" mode=\
    dynamic-keys supplicant-identity=MikroTik wpa2-pre-shared-key=1234554321
/ip hotspot profile
set [ find default=yes ] html-directory=flash/hotspot
/ip pool
add name=default-dhcp ranges=192.168.88.10-192.168.88.254
/ip dhcp-server
add address-pool=default-dhcp disabled=no interface=bridge name=defconf
/interface bridge port
add bridge=bridge comment=defconf disabled=yes interface=ether1
add bridge=bridge comment=defconf interface=wlan1
add bridge=br-v210 interface=v210_eth1
add bridge=br-v210 interface=eoip-mng-uman
/ip neighbor discovery-settings
set discover-interface-list=all
/interface list member
add comment=defconf interface=bridge list=LAN
add comment=defconf interface=lte1 list=WAN
/ip address
add address=192.168.88.1/24 comment=defconf interface=bridge network=\
    192.168.88.0
add address=10.10.10.1/24 interface=v10_eth1 network=10.10.10.0
add address=172.21.70.10/24 interface=v70_eth1 network=172.21.70.0
/ip dhcp-client
add add-default-route=no dhcp-options=hostname,clientid disabled=no \
    interface=v2_eth1 use-peer-dns=no use-peer-ntp=no
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
    ipsec-policy=out,none
/ip route
add distance=1 dst-address=172.20.1.30/32 gateway=172.21.70.1
add distance=1 dst-address=172.21.0.0/16 gateway=172.21.70.1
/ip ssh
set allow-none-crypto=yes
/snmp
set enabled=yes
/system clock
set time-zone-name=Europe/Kiev
/system gps
set port=serial0
/system identity
set name="ltAP-10.1 (MTS/Kyivstar)"
/system logging
add disabled=yes topics=lte
/system scheduler
add interval=2m name=check_sim_down on-event=switch_sim policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=apr/18/2019 start-time=11:47:04
add interval=1m name=send_lte_data on-event=send_lte_data policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
add interval=30m name=reboot_on_hang on-event=reboot_on_hang policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
/system script
add dont-require-permissions=no name=switch_sim owner=railroad policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="{\
    \n\t:global initTimeout 60\
    \n\t:global connectTimeout 60\
    \n\t:global minimumSignalLevel -115\
    \n\
    \n\t:global switchSIM do={\
    \n\t\t:local simSlot [/system routerboard sim get sim-slot]\
    \n\
    \n\t\t:if (\$simSlot=\"down\") do={\
    \n\t\t\t:log info message=\"Switching to \\\"up\\\" sim slot (Kyivstar)\"\
    \n\t\t\t/system routerboard sim set sim-slot=up\
    \n\t\t} else={\
    \n\t\t\t:log info message=\"Switching to \\\"down\\\" sim slot (MTS)\"\
    \n\t\t\t/system routerboard sim set sim-slot=down\
    \n\t\t}\
    \n\t}\
    \n\
    \n\t:global initialize do={\
    \n\t\t:global initTimeout\
    \n\
    \n\t\t:local i 0\
    \n\t\t:while (\$i < \$initTimeout) do={\
    \n\t\t\t:if ([:len [/interface lte find ]] > 0) do={\
    \n\t\t\t\t:return true\
    \n\t\t\t}\t\t\t\
    \n\t\t\t:set \$i (\$i+1)\
    \n\t\t\t:delay 1s\
    \n\t\t}\
    \n\
    \n\t\t:return false\
    \n\t}\
    \n\
    \n\t:global waitConnect do={\
    \n\t\t:global connectTimeout\
    \n\
    \n\t\t:local i 0\
    \n\t\t:while (\$i < \$connectTimeout) do={\
    \n\t\t\t:if ([/interface lte get [find name=\"lte1\"] running] = true) do=\
    {\
    \n\t\t\t\t:return true\
    \n\t\t\t}\
    \n\t\t\t:set \$i (\$i+1)\
    \n\t\t\t:delay 1s\
    \n\t\t}\
    \n\
    \n\t\t:return false\
    \n\t}\
    \n\
    \n\t:if ([\$initialize] = true) do={\
    \n\t\t:if ([\$waitConnect] = true) do={\
    \n\t\t\t:local info [/interface lte info lte1 once as-value]\
    \n\t\t\t:local rssi (\$info->\"rssi\")\
    \n\t\t\t\
    \n\t\t\t:if (\$rssi = nil) do={\
    \n\t\t\t\t:local rsrp (\$info->\"rsrp\")\
    \n\t\t\t\t:log info message=(\"LTE RSRP\".\$rsrp)\
    \n\t\t\t\t:if (\$rsrp < \$minimumSignalLevel) do={\
    \n\t\t\t\t\t:log info message=(\"Current RSSI \".\$rsrp.\" < \".\$minimumS\
    ignalLevel.\". Trying to switch active sim slot.\")\
    \n\t\t\t\t\t\$switchSIM\
    \n\t\t\t\t}\
    \n\t\t\t} else={\
    \n\t\t\t\t:if (\$rssi < \$minimumSignalLevel) do={\
    \n\t\t\t\t\t:log info message=(\"Current RSSI \".\$rssi.\" < \".\$minimumS\
    ignalLevel.\". Trying to switch active sim slot.\")\
    \n\t\t\t\t\t\$switchSIM\
    \n\t\t\t\t}\
    \n\t\t\t}\
    \n\t\t} else={\
    \n\t\t\t:log info message=\"GSM network is not connected. Trying to switch\
    \_active sim slot.\"\
    \n\t\t\t\$switchSIM\
    \n\t\t}\
    \n\t} else={\
    \n\t\t:log info message=\"LTE modem did not appear, trying power-reset\"\
    \n\t\t/system routerboard usb power-reset duration=5s\
    \n\t}\t\t\
    \n}\
    \n"
add dont-require-permissions=no name=send_lte_data owner=railroad policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":\
    local info [/interface lte info lte1 once as-value]\
    \n\
    \n\
    \n\
    \n:local at (\$info->\"access-technology\")\
    \n\
    \n:local operator (\$info->\"current-operator\")\
    \n\
    \n:local rssi (\$info->\"rssi\")\
    \n\
    \n:local signal\
    \n\
    \n:if (\$rssi = nil) do={\
    \n\
    \n\t\t\t\t:set signal (\$info->\"rsrp\")\
    \n\
    \n\t\t\t} else={\
    \n\
    \n\t\t\t\t:set signal (\$info->\"rssi\")\
    \n\
    \n\t\t\t}\
    \n\
    \n\
    \n\
    \n:log info \$at\
    \n\
    \n:log info \$operator\
    \n\
    \n:log info \$signal\t\t\
    \n\
    \n\
    \n\
    \ntool fetch mode=http url=\"http://inwhite.com.ua/matrisa.php\" port=80 h\
    ttp-method=post http-data=(\"{\\\"at\\\":\\\"\" . \$at . \"\\\",\\\"operat\
    or\\\":\\\"\" . \$operator . \"\\\", \\\"signal\\\":\\\"\" . \$signal . \"\
    \\\"}\") http-header-field=\"Content-Type: application/json\" \
    \n\
    \n:put (\"{\\\"at\\\":\\\"\" . \$at . \"\\\",\\\"operator\\\":\\\"\" . \$o\
    perator . \"\\\", \\\"signal\\\":\\\"\" . \$signal . \"\\\"}\")\
    \n\
    \n}\
    \n\
    \n"
add dont-require-permissions=no name=reboot_on_hang owner=railroad policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":\
    if ( [/ping 8.8.8.8 count=10 size=64 interval=2s ] =0) do={\r\
    \n:log error \"-----No ping\";\r\
    \n/system routerboard usb power-reset duration=10;\r\
    \n:log error \"----Reset USB Power\";\r\
    \n} else={\r\
    \n:log info \"-----LTE OK-----\";\r\
    \n}"
/tool mac-server mac-winbox
set allowed-interface-list=LAN
/tool netwatch
add down-script="/interface lte disable 0 \r\
    \n/interface lte enable 0" host=8.8.8.8 interval=15m timeout=30s
