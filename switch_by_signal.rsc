	:global initTimeout 60
	:global connectTimeout 60
	:global minimumSignalLevel -115

	:global switchSIM do={
		:local simSlot [/system routerboard sim get sim-slot]

		:if ($simSlot="down") do={
			:log info message="Switching to \"up\" sim slot (Kyivstar)"
			/system routerboard sim set sim-slot=up
		} else={
			:log info message="Switching to \"down\" sim slot (MTS)"
			/system routerboard sim set sim-slot=down
		}
	}

	:global initialize do={
		:global initTimeout

		:local i 0
		:while ($i < $initTimeout) do={
			:if ([:len [/interface lte find ]] > 0) do={
				:return true
			}			
			:set $i ($i+1)
			:delay 1s
		}

		:return false
	}

	:global waitConnect do={
		:global connectTimeout

		:local i 0
		:while ($i < $connectTimeout) do={
			:if ([/interface lte get [find name="lte1"] running] = true) do={
				:return true
			}
			:set $i ($i+1)
			:delay 1s
		}

		:return false
	}

	:if ([$initialize] = true) do={
		:if ([$waitConnect] = true) do={
			:local info [/interface lte info lte1 once as-value]
			:local rssi ($info->"rssi")
			
			:if ($rssi = nil) do={
				:local rsrp ($info->"rsrp")
				:log info message=("LTE RSRP".$rsrp)
				:if ($rsrp < $minimumSignalLevel) do={
					:log info message=("Current RSSI ".$rsrp." < ".$minimumSignalLevel.". Trying to switch active sim slot.")
					$switchSIM
				}
			} else={
				:if ($rssi < $minimumSignalLevel) do={
					:log info message=("Current RSSI ".$rssi." < ".$minimumSignalLevel.". Trying to switch active sim slot.")
					$switchSIM
				}
			}
		} else={
			:log info message="GSM network is not connected. Trying to switch active sim slot."
			$switchSIM
		}
	} else={
		:log info message="LTE modem did not appear, trying power-reset"
		/system routerboard usb power-reset duration=5s
	}		