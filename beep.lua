local M = {}

local beep_pin

local SHORT_BEEP=200
local MEDIUM_BEEP=500
local LONG_BEEP=1000
local _tmr

local function beep(d) 
    _tmr:register(d,tmr.ALARM_SINGLE, function() 
            gpio.write(beep_pin,gpio.LOW)
        end)
    gpio.write(beep_pin,gpio.HIGH)
    _tmr:start()
end

function M.init(p)
    _tmr = tmr.create()
    beep_pin = p
    gpio.mode(beep_pin,gpio.OUTPUT)
end

function M.short()
    beep(SHORT_BEEP)
end

function M.medium()
    beep(MEDIUM_BEEP)
end

function M.long()
    beep(LONG_BEEP)
end


return M
