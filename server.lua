client = mqtt.Client("ID"..chipid, 120)
client:lwt("/lwt", "offline", 0, 0)
client:on("offline", function(client) 
    --node.restart() 
    print("Queue offline, restarting")
end)

client:lwt("/lwt", "offline", 0, 0)

     
client:on("offline", function(client) print ("offline") end)

-- on publish message receive event
client:on("message", function(client, topic, data) 
  print(topic .. ":" .. " msg=" .. data) 
  if data == "start" then l_start(client)
  else if data == "abort" then l_pattern(8) 
  else if data == "clear" then l_clear() 
  else if data == "safety_car" then l_safety_car() 
  else if data == "green" then l_pattern(4) 
  else if data == "stop" then l_pattern(3) 
  end end end end end end
end)

action = {
    start = function(client) lights:start(client) end
}

client:connect(IP, 1883, 0,
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




