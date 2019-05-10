# Setup and read current values, "up" SIM slot will be used for roaming, "down" for home network
:global simSlot [/system routerboard sim get sim-slot]
:global timeoutLTE 60
:global timeoutConnect 60
:global lastTechnology
:global checkInterval

:local egprs "GSM EGPRS"
:local lte "Evolved 3G (LTE)"


# Wait for LTE to initialize for maximum "timeoutLTE" seconds
:local i 0
:local isLTEinit false
:while ($i<$timeoutLTE) do={
    :foreach n in=[/interface lte find] do={:set $isLTEinit true}
    :if ($isLTEinit=true) do={
        :set $i $timeoutLTE
    }
    :set $i ($i+1)
    :delay 1s
}

# Check if LTE is initialized, or try power-reset the modem
:if ($isLTEinit=true) do={
    # Wait for LTE interface to connect to mobile network for maximum "timeoutConnet" seconds
    :local isConnected false
    :set $i 0
    :while ($i<$timeoutConnect) do={
        :if ([/interface lte get [find name="lte1"] running]=true) do={
            :set $isConnected true
            :set $i $timeoutConnect
        }
        :set $i ($i+1)
        :delay 1s
    }
    # Check if LTE is connected
    if ($isConnected=true) do={
        :local Info [/interface lte info [find name="lte1"] once as-value]
		:local operator ($Info->"current-operator")
		:local technology ($Info->"access-technology")
        # Check which SIM slot is used
        :if ($simSlot="down") do={
			:log info message="Operator $operator, technology $technology, last technology $lastTechnology"
			:if ($technology=$egprs) do={
                :log info message="EGPRS detected, switching to SIM UP"
				:if ($lastTechnology="egprs") do={
					:log info message="Previous technology was egprs too"
					/system scheduler set [find name="checkTechnology"] interval="10m"
				} 
			} else={
				:log info message="LTE/3G detected"
				:if ($lastTechnology="egprs") do={
						system scheduler set [find name="checkTechnology"] interval="1m"
						:global lastTechnology ""	
				}
				}
        } else={
            
        }
    } else={
        :log info message="LTE interface did not connect to network, wait for next scheduler"
    }
} else={
    :log info message="LTE modem did not appear, trying power-reset"
    /system routerboard usb power-reset duration=5s
}