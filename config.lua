-- Boot pins
PIN_WIFI_RESET=5
PIN_BOOT_BYPASS=4

-- Determines which light interface is to be used
LIGHT_MODULE=tm1637

-- Lights
CLK_PIN=7
DIO_PIN=6
BRIGHTNESS=255

-- Beep
BEEP_PIN=3

-- Between lights
STEP_TIME=1000

-- Network
NTP_HOST="pool.ntp.org"
MQTT_HOST="192.168.0.124"

START_TOPIC="/game/app/ui/admin/race/start"
STOP_TOPIC="/game/app/ui/admin/race/stop"
GO_TOPIC="/game/device/ESP/lightCountDown"

