-- SERVER 
SERVER="server"

-- REQUIRED MODULES
DEPENDS = {"beep","tm1637","tm1637_lights","ws2812_lights",SERVER}
MODULES = {"globals.lua","wifi_setup.lua"} 


-- Boot pins
PIN_WIFI_RESET=7

-- Determines which light interface is to be used
LIGHT_MODULE="tm1637"
--LIGHT_MODULE="ws2812"

if(LIGHT_MODULE == "tm1637") then
    CLK_PIN=3
    DIO_PIN=2
    BRIGHTNESS=7 -- 0 - 7
    NO_LED=5
else if(LIGHT_MODULE == "ws2812") then
    -- DISPLAY
    NO_LED=8
    COLOR_DEPTH=3
    BRIGHTNESS=255 -- 0 to 255
end end

-- Beep
BEEP_PIN=5

-- Between lights
STEP_TIME=math.floor(1000 * (5 / NO_LED))

-- NETWORK
NTP_HOST="pool.ntp.org"
MQTT_HOSTS={
    {subnet="192.168.100.",server="mqtt.reeuwijk.net"},
    {subnet="192.168.0.",server="192.168.0.124"}
}

-- TOPICS
START_TOPIC="/game/app/ui/admin/race/start"
STOP_TOPIC="/game/app/ui/admin/race/stop"
GO_TOPIC="/game/device/ESP/lightCountDown"


