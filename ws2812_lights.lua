local M = {}

local _tmr

local _beeper
local _buffer
local _refresh

function M.init()
    ws2812.init()
    _buffer = ws2812.newBuffer(NO_LED, COLOR_DEPTH)
    
    _refresh = tmr.create():alarm(100, tmr.ALARM_AUTO, function()
    local d = adc.read(0)
    local bright = math.floor(d/4)
    if(bright>255) then bright = 255 end
    if(bright<1) then bright = 1 end
        if(math.abs(bright-BRIGHTNESS)>5) then
            print("Brightness="..bright)
            BRIGHTNESS = bright
            for i=1,NO_LED do
                local g,r,b = _buffer:get(i)
                if(r>0) then r=bright end
                if(g>0) then g=bright end
                if(b>0) then b=bright end
                _buffer:set(i,g,r,b)
            end
        end
        ws2812.write(_buffer)
    end)

    _tmr = tmr.create()
    _beeper = require('beep')
    _beeper.init(BEEP_PIN)
end


function _fill(r,g,b)
    _buffer:fill(g,r,b)
end

function _pattern(c)
    _tmr:stop()
    _tmr:unregister()
    local r,g,b =  bit.band(1,c),bit.rshift(bit.band(c,2),1),bit.rshift(bit.band(c,4),2)
    _fill(r*BRIGHTNESS,g*BRIGHTNESS,b*BRIGHTNESS) --Yellow
end

function M.clear()
    _pattern(0)
end

function M.safety_car()
    _buffer:fill(0,0,0)
    _buffer:set(1,{BRIGHTNESS,BRIGHTNESS,0})
    _buffer:set(3,{BRIGHTNESS,BRIGHTNESS,0})
    _buffer:set(5,{BRIGHTNESS,BRIGHTNESS,0})
    _buffer:set(7,{BRIGHTNESS,BRIGHTNESS,0})
    _tmr:alarm(500,tmr.ALARM_AUTO,
        function()
            _buffer:shift(1,ws2812.SHIFT_CIRCULAR)
        end)
end

function M.start(callback)
    local i = NO_LED
    _pattern(2)
    _beeper.medium()
    tmr.delay(STEP_TIME)
    _tmr:alarm(STEP_TIME,tmr.ALARM_AUTO, function()
        print("Step "..i)
        _buffer:set(i,{0,BRIGHTNESS,0})
        _beeper.short()
        if(i == 1) then
            _tmr:stop()
            _tmr:unregister()
            local _r = node.random(2*STEP_TIME,4*STEP_TIME)
            print("Start in ".._r.." ms.")
            _tmr:alarm(_r,tmr.ALARM_SINGLE, 
                function()
                    _beeper.medium()
                    if(not (callback == nil)) then
                        --client:publish(GO_TOPIC,"start", 0, 0, function(client) print("sent") end)
                        callback()
                    else
                        print("Callback is nil")
                    end
                    _pattern(2)
                end)
        end
        i = i - 1
    end)
end

function M.stop()
    _pattern(1) -- RED
end

function M.green()
    _pattern(2) -- GREEN
end

function M.abort()
    _pattern(3) -- YELLOW
end

return M