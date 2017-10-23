wifi.sta.autoconnect(1)

wifi.eventmon.register(wifi.eventmon.STA_GOT_IP,
    function(T)
        local beeper = require('beep')
        beeper.init(BEEP_PIN)
        beeper.short()
        print("\n\tSTA - GOT IP".."\n\tStation IP: "..T.IP.."\n\tSubnet mask: "..
            T.netmask.."\n\tGateway IP: "..T.gateway)
        print("Starting Time Sync")
        net.dns.resolve(NTP_HOST, function(sk, ip)
            if (ip == nil) then print("DNS fail!") 
            else           
                sntp.sync(ip, function(sec,usec,server)
                     print('sync', sec, usec, server)
                end,
                function()
                   print('NTP Sync failed!')
                end)
            end
        end)
        print("Looking for MQTT server")
        net.dns.resolve(MQTT_HOST, function(sk, ip)
            if (ip == nil) then print("DNS fail!") 
            else 
                IP=ip
                print("Starting Server")
                dofile("server.lc")
            end
        end)
    end)

tmr.create():alarm(10000, tmr.ALARM_SINGLE, 
    function()
        if wifi.sta.getip() == nil then
            print("We have no IP")
            enduser_setup.start(
                function()
                    print("Connected to wifi as:" .. wifi.sta.getip())
                end,
                function(err, str)
                    print("enduser_setup: Err #" .. err .. ": " .. str)
                end)
         else
            print("We got IP "..wifi.sta.getip())
         end
    end)

station_cfg={}
station_cfg.ssid=WIFI_SSID
station_cfg.pwd=WIFI_PASSWORD
wifi.sta.config(station_cfg)
