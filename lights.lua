seq_t = tmr.create()

tm1637 = require('tm1637')
tm1637.init(CLK_PIN, DIO_PIN)
tm1637.set_brightness(BRIGHTNESS) 

beeper = require('beep')
beeper.init(BEEP_PIN)

function l_clear()
    seq_t:stop()
    seq_t:unregister()
    tm1637.clear()
end

function l_start(client)
    seq_t:register(STEP_TIME,tmr.ALARM_SINGLE, 
        function()
            for i=0,4 do
                tm1637.column(i,4)
            end
            beeper.medium()
            seq_t:register(STEP_TIME,tmr.ALARM_SINGLE, 
                function()
                    tm1637.column(4,7)
                    beeper.short()
                    seq_t:register(STEP_TIME,tmr.ALARM_SINGLE, 
                        function()
                            tm1637.column(3,7)
                            beeper.short()
                            seq_t:register(STEP_TIME,tmr.ALARM_SINGLE, 
                                function()
                                    tm1637.column(2,7)
                                    beeper.short()
                                    seq_t:register(STEP_TIME,tmr.ALARM_SINGLE, 
                                        function()
                                            tm1637.column(1,7)
                                            beeper.short()
                                            seq_t:register(STEP_TIME,tmr.ALARM_SINGLE, 
                                                function()
                                                    tm1637.column(0,7)
                                                    beeper.short()
                                                    local _r = node.random(2*STEP_TIME,4*STEP_TIME)
                                                    print("Start in ".._r.." ms.")
                                                    seq_t:register(_r,tmr.ALARM_SINGLE, 
                                                        function()
                                                            beeper.medium()
                                                            if(not not client) then
                                                                client:publish(GO_TOPIC,"start", 0, 0, function(client) print("sent") end)
                                                            end
                                                            for i=0,4 do
                                                                tm1637.column(i,4)
                                                            end
                                                        end)
                                                    seq_t:start()
                                                end)
                                            seq_t:start()
                                        end)
                                    seq_t:start()
                                end)
                            seq_t:start()
                        end)
                    seq_t:start()
                end)
            seq_t:start()
        end)        
    seq_t:start()
end

function l_safety_car()
    seq_t:register(STEP_TIME,tmr.ALARM_AUTO,
        function()
            for i=0,4 do
                tm1637.column(i,8)
            end
            tmr.delay(STEP_TIME/2)
            for i=0,4 do
                tm1637.column(i,0)
            end
        end)
    seq_t:start()
end

function l_pattern(c)
    for i=0,4 do
        tm1637.column(i,c)
    end
    --seq_t:stop()
end
