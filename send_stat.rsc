:local info [/interface lte info lte1 once as-value]

:log info $info

:local at ($info->"access-technology")

:local operator ($info->"current-operator")

:local rssi ($info->"rssi")

:local signal

:local lac ($info->"lac")

:local cid ($info->"current-cellid");

:if ($rssi = nil) do={

				:set signal ($info->"rsrp")

			} else={

				:set signal ($info->"rssi")

			}


:set operator "external";

:log info $at

:log info $operator

:log info $signal
:log info $cid
:log info $lac





tool fetch mode=http url="http://inwhite.com.ua/matrisa.php" port=80 http-method=post http-data=("{\"lac\":\"" . $lac . "\",\"cid\":\"" . $cid . "\",\"at\":\"" . $at . "\",\"operator\":\"" . $operator . "\", \"signal\":\"" . $signal . "\"}") http-header-field="Content-Type: application/json" 

:put ("{\"lac\":\"" . $lac . "\",\"cid\":\"" . $cid . "\",\"at\":\"" . $at . "\",\"operator\":\"" . $operator . "\", \"signal\":\"" . $signal . "\"}")

}

