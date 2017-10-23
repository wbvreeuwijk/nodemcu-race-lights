print("Traffic light firmware v2.0")
node.setcpufreq(node.CPU160MHZ)

-- FAIL SAFE
gpio.mode(4,gpio.INPUT)
if(gpio.read(4) == 1) then 
    print("Starting ...")
    modules =  {"config.lua","globals.lua","lights.lc","wifi_setup.lua"} 
    
    for i in pairs(modules) do
        if(file.exists(modules[i])) then 
            print("Executing: "..modules[i])
            dofile(modules[i]) 
        end
    end
end

-- in you init.lua:
if adc.force_init_mode(adc.INIT_VDD33)
then
  node.restart()
  return -- don't bother continuing, the restart is scheduled
end

