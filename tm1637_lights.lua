local M = {}

local _tmr

local _tm1637
local _beeper

function M.init()
    _tmr = tmr.create()
    _tm1637 = require('tm1637')
    _tm1637.init(CLK_PIN, DIO_PIN)
    _tm1637.set_brightness(BRIGHTNESS) 
    _beeper = require('beep')
    _beeper.init(BEEP_PIN)
end

function _stop()
    _tmr:stop()
    _tmr:unregister()
end

function M.clear()
    _stop()
    _tm1637:clear()
end

function M.safety_car()
    _tmr:register(STEP_TIME,tmr.ALARM_AUTO,
        function()
            for i=1,NO_LED do
                _tm1637.column(i,8)
            end
            tmr.delay(STEP_TIME/2)
            for i=1,NO_LED do
                _tm1637.column(i,0)
            end
        end)
    _tmr:start()
end

function M.stop()
    _pattern(3) -- BOTTOM TWO RED LEDS
end

function M.green()
    _pattern(4) -- MIDDLE ROW GREEN LEDS
end

function M.abort()
    _pattern(8) -- TOP ROW YELLOW LEDS
end

function M.start(callback)
    local i = NO_LED
    _pattern(4) -- GREEN LEDS
    _beeper:medium()
    tmr.delay(STEP_TIME)
    _tmr:alarm(STEP_TIME,tmr.ALARM_AUTO, function()
        print("Step "..i)
        _tm1637.column(i,7)
        _beeper:short()
        if(i == 1) then
            _tmr:stop()
            _tmr:unregister()
            local _r = node.random(2*STEP_TIME,4*STEP_TIME)
            print("Start in ".._r.." ms.")
            _tmr:alarm(_r,tmr.ALARM_SINGLE, 
                function()
                    _beeper:medium()
                    if(not (callback == nil)) then
                        --client:publish(GO_TOPIC,"start", 0, 0, function(client) print("sent") end)
                        callback()
                    else
                        print("Callback is nil")
                    end
                    _pattern(4)
                end)
        end
        i = i-1
    end)
end

function _pattern(c)
    _stop()
    for i=1,NO_LED do
        _tm1637.column(i,c)
    end    
end

return M