print("Traffic light firmware v2.1")

PIN_WIFI_RESET=6
PIN_BOOT_BYPASS=4

gpio.mode(PIN_WIFI_RESET,gpio.INT,gpio.PULLUP)
gpio.trig(PIN_WIFI_RESET, "down", function(level, when)
    print("Reset Wifi...")
    wifi.sta.clearconfig()
    tmr.delay(100)
    node.restart()
end)


-- FAIL SAFE
gpio.mode(PIN_BOOT_BYPASS,gpio.INPUT,gpio.PULLUP)
if(gpio.read(PIN_BOOT_BYPASS) == 1) then
    print("Starting ...")
    modules =  {"config.lua","globals.lua","lights.lua","wifi_setup.lua"} 
    
    for i in pairs(modules) do
        if(file.exists(modules[i])) then 
            print("Executing: "..modules[i])
            dofile(modules[i]) 
        end
    end
else
    print("Bypassing init.lua")
end
-- in you init.lua:
if adc.force_init_mode(adc.INIT_ADC)
then
  node.restart()
  return -- don't bother continuing, the restart is scheduled
end

