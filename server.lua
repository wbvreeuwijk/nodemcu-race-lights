local M = {}

local _client
local _lights

function M.init()
    print("Init lights")
    _lights = require(LIGHT_MODULE.."_lights")
    _lights.init()

    print("Init mqtt")
    _client = mqtt.Client("ID"..chipid, 120)
    _client:lwt("/lwt", "offline", 0, 0)
    _client:on("offline", function(client) 
        --node.restart() 
        print("Queue offline, restarting")
    end)

    _client:lwt("/lwt", "offline", 0, 0)
   
    _client:on("offline", function(client) print ("offline") end)

    print("Register callback")
    -- on publish message receive event
    _client:on("message", function(client, topic, data) 
      print(topic .. ":" .. " msg=" .. data) 
      if data == "start" then _lights.start(
        function() 
            _client:publish(GO_TOPIC,"start", 0, 0, 
                function(client) print("sent") 
            end)
        end)
      else if data == "abort" then _lights:abort()
      else if data == "clear" then _lights:clear() 
      else if data == "safety_car" then _lights:safety_car() 
      else if data == "green" then _lights:green() 
      else if data == "stop" then _lights:stop() 
      end end end end end end
    end)
    
    action = {
        start = function(client) lights:start(client) end
    }
end

function M.start(mqtt_ip)
    print("Trying to connect to "..mqtt_ip)
    _client:connect(mqtt_ip, 1883, 0,
        function(client)
            print("Connected")
            tmr.create():alarm(1000,tmr.ALARM_SINGLE,function()
                client:subscribe(START_TOPIC, 0,  
                    function(client)   
                        print("subscribed to START")
                    end)
                 end)
            tmr.create():alarm(2000,tmr.ALARM_SINGLE,function()
                client:subscribe(STOP_TOPIC, 0,  
                    function(client)   
                        print("subscribed to STOP")
                    end)
                end)
         end,
         function(client, reason)
             print("failed reason: " .. reason)
         end)
end

return M


