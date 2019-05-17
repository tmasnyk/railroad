# may/17/2019 10:19:26 by RouterOS 6.44.2
# software id = U00G-C7P2
#
# model = 960PGS
# serial number = AD8A0985C142
/caps-man channel
add band=2ghz-b/g/n control-channel-width=20mhz extension-channel=disabled \
    frequency=2412 name=2412 tx-power=25
add band=5ghz-a/n/ac control-channel-width=20mhz extension-channel=disabled \
    frequency=5300 name=5300 tx-power=25
/interface bridge
add fast-forward=no name=br-wlan
add admin-mac=B8:69:F4:E5:9F:91 auto-mac=no comment=defconf name=br_mng
add name=br_mng_uman
/interface ethernet
set [ find default-name=ether1 ] speed=100Mbps
set [ find default-name=ether2 ] comment="ltAP-10.1 MTS/Kyivstar" speed=\
    100Mbps
set [ find default-name=ether3 ] comment="ltAP-11.1 Life/Intertelecom" speed=\
    100Mbps
set [ find default-name=ether4 ] comment=wAP speed=100Mbps
set [ find default-name=ether5 ] speed=100Mbps
set [ find default-name=sfp1 ] advertise=\
    10M-half,10M-full,100M-half,100M-full,1000M-half,1000M-full
/interface pptp-client
add connect-to=91.206.252.10 disabled=no keepalive-timeout=3 name=kiev \
    password=railroad2019 user=railroad
add connect-to=91.245.105.0 disabled=no keepalive-timeout=20 name=taras-home \
    password=railroad2019 user=railroad
add connect-to=193.43.95.6 disabled=no keepalive-timeout=5 name=uman-mng \
    password=railroad2019 user=railroad
/interface eoip
add mac-address=02:E8:1C:54:54:7E name=eoip-kiev remote-address=192.168.113.1 \
    tunnel-id=202
add mac-address=02:E8:1C:54:54:7E name=eoip-taras remote-address=192.168.88.1 \
    tunnel-id=201
add loop-protect=off mac-address=02:06:C2:16:D9:D0 name=eoip-uman \
    remote-address=172.21.56.1 tunnel-id=56
/interface vlan
add interface=ether2 name=v2_eth2 vlan-id=2
add interface=ether3 name=v2_eth3 vlan-id=2
add interface=ether4 name=v2_eth4 vlan-id=2
add interface=ether2 name=v10-eth2 vlan-id=10
add interface=ether3 name=v10-eth3 vlan-id=10
add interface=ether4 name=v11_eth4 vlan-id=11
add interface=ether2 name=v70_eth2 vlan-id=70
add interface=ether3 name=v70_eth3 vlan-id=70
add interface=ether4 name=v70_eth4 vlan-id=70
add interface=ether2 name=v210_eth2 vlan-id=210
add interface=ether3 name=v211_eth3 vlan-id=211
/interface bonding
add disabled=yes mode=802.3ad name=bonding-mng slaves=v210_eth2,v211_eth3 \
    transmit-hash-policy=layer-3-and-4
/caps-man datapath
add bridge=br-wlan name=datapath1
/caps-man security
add authentication-types=wpa2-psk encryption=aes-ccm name=security1 \
    passphrase=18042019
/caps-man configuration
add channel=2412 country=ukraine datapath=datapath1 mode=ap name=cfg1 \
    security=security1 ssid=matrisa1
/caps-man interface
add channel=2412 configuration=cfg1 disabled=no l2mtu=1600 mac-address=\
    B8:69:F4:3B:07:D4 master-interface=none name=cap2G radio-mac=\
    B8:69:F4:3B:07:D4 radio-name=B869F43B07D4
add channel=5300 configuration=cfg1 disabled=no l2mtu=1600 mac-address=\
    B8:69:F4:3B:07:D3 master-interface=none name=cap5G radio-mac=\
    B8:69:F4:3B:07:D3 radio-name=B869F43B07D3
/interface list
add comment=defconf name=WAN
add comment=defconf name=LAN
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip hotspot profile
set [ find default=yes ] html-directory=flash/hotspot
/ip pool
add name=default-dhcp ranges=192.168.88.10-192.168.88.254
add name=dhcp_pool1 ranges=192.168.5.2-192.168.5.254
add name=dhcp_pool2 ranges=192.168.6.2-192.168.6.254
add name=dhcp_pool3 ranges=192.168.5.2-192.168.5.254
add name=dhcp_pool4 ranges=192.168.100.2-192.168.100.254
/ip dhcp-server
add address-pool=default-dhcp interface=br_mng name=defconf
add address-pool=dhcp_pool2 interface=ether3 name=dhcp-eth3
add address-pool=dhcp_pool3 disabled=no interface=v11_eth4 name=dhcp1
add address-pool=dhcp_pool4 disabled=no interface=br-wlan name=dhcp2
/caps-man manager
set enabled=yes
/interface bridge port
add bridge=br_mng interface=ether1
add bridge=br_mng interface=v2_eth2
add bridge=br_mng interface=v2_eth3
add bridge=br_mng interface=v2_eth4
add bridge=br_mng interface=eoip-taras
add bridge=br_mng interface=eoip-kiev
add bridge=br_mng_uman interface=eoip-uman
add bridge=br_mng_uman interface=v70_eth2
add bridge=br_mng_uman interface=v70_eth3
add bridge=br_mng_uman interface=v70_eth4
/ip neighbor discovery-settings
set discover-interface-list=all
/interface list member
add comment=defconf interface=br_mng list=LAN
add comment=defconf interface=ether1 list=WAN
add comment=defconf interface=v10-eth2 list=WAN
add comment=defconf interface=v10-eth3 list=WAN
add interface=br-wlan list=WAN
/ip address
add address=192.168.88.1/24 comment=defconf disabled=yes interface=br_mng \
    network=192.168.88.0
add address=192.168.5.1/24 interface=v11_eth4 network=192.168.5.0
add address=192.168.6.1/24 disabled=yes interface=ether4 network=192.168.6.0
add address=10.10.10.2/24 interface=v10-eth2 network=10.10.10.0
add address=192.168.100.1/24 interface=br-wlan network=192.168.100.0
add address=10.10.11.2/24 interface=v10-eth3 network=10.10.11.0
add address=172.21.70.12/24 interface=br_mng_uman network=172.21.70.0
add address=192.168.211.2/24 interface=bonding-mng network=192.168.211.0
add address=192.168.212.2/24 interface=v211_eth3 network=192.168.212.0
/ip dhcp-client
add add-default-route=no comment=defconf dhcp-options=hostname,clientid \
    disabled=no interface=br_mng
add default-route-distance=10 dhcp-options=hostname,clientid interface=\
    v10-eth2
add default-route-distance=10 dhcp-options=hostname,clientid interface=ether3
add default-route-distance=20 dhcp-options=hostname,clientid interface=\
    v10-eth3
/ip dhcp-server network
add address=192.168.5.0/24 dns-server=192.168.5.1 gateway=192.168.5.1
add address=192.168.100.0/24 dns-server=192.168.100.1 gateway=192.168.100.1
/ip dns
set allow-remote-requests=yes servers=1.1.1.1
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
add check-gateway=ping comment=MTS/Kyivstar distance=10 gateway=8.8.4.4
add check-gateway=ping comment=Life/Intertelecom distance=20 gateway=8.8.8.8
add distance=1 dst-address=8.8.4.4/32 gateway=10.10.10.1 scope=10
add distance=1 dst-address=8.8.8.8/32 gateway=10.10.11.1 scope=10
add distance=1 dst-address=172.20.1.30/32 gateway=172.21.70.1
add distance=1 dst-address=172.21.0.0/16 gateway=172.21.70.1
/ip ssh
set allow-none-crypto=yes
/snmp
set enabled=yes
/system clock
set time-zone-name=Europe/Kiev
/system identity
set name=Railroad_hEX_PoE
/system logging
add disabled=yes topics=script,debug
/system scheduler
add name=schedule1 policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=apr/15/2019 start-time=14:30:56
/system script
add dont-require-permissions=no name=script1 owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":\
    global Status ([/system ssh address=10.10.11.1 command=\"interface lte inf\
    o 0 once as-value\"] );\r\
    \n:log info \$Status;"
add dont-require-permissions=yes name=lte_log owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":\
    global Status (:get[/system ssh address=10.10.11.1 command= \":put [/inter\
    face  lte  info  0  once  as-value]\"])\r\
    \n:log info \"Hello\":"
add dont-require-permissions=no name=script3 owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":\
    local Status ([/system ssh address=10.10.10.1 command=\":put ([/interface \
    ethernet monitor [find where name=ether1] once as-value]->\\\"status\\\")\
    \" as-value]->\"output\")\r\
    \n:log info \"hello\";"
add dont-require-permissions=no name=script4 owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":\
    global GoldenUser; :global GoldenIP\r\
    \n:local myMac E4:8D:8C:26:DC:03\r\
    \ndo {\r\
    \n    :local out [ system ssh address=10.10.11.1 command=\":put [/interfac\
    e ethernet monitor [find where name=ether1] once as-value]\"]\r\
    \n    :log info \"out:\$out:\"\r\
    \n} on-error={\r\
    \n    :log error \"ERR\"\r\
    \n}"
add dont-require-permissions=no name=script5 owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":\
    local result [/tool fetch url=http://bash.im as-value output=user];\r\
    \n:log info \$result:"
add dont-require-permissions=yes name=snmp owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":\
    global Status ([/tool snmp-walk 10.10.11.1 version=1 community=public oid=\
    1.3.6.1.4.1.14988.1.1.16.1.1.6])\r\
    \n:log info \"Hello\":"
/tool mac-server
set allowed-interface-list=LAN
/tool mac-server mac-winbox
set allowed-interface-list=LAN
