local config = dofile("alarm_config.cfg")
local modem = peripheral.find("modem") or error("Modem requis!")
local alarmActive = false

modem.open(config.trigger_frequency)
modem.open(config.receiver_frequency)

modem.transmit(config.receiver_frequency,0,{key = config.secret_key, cmd = "stop"})

term.clear()
print("---------------------------")
print("| CIUCCAD SECURITY SYSTEM |")
print("---------------------------")
print("- Security server ready")

parallel.waitForAny(
function()
    while true do
        local _, freq, reply, msg = os.pullEvent("modem_message")
        print(freq)
        if freq == config.trigger_frequency and msg.key == config.secret_key then
            if msg.cmd == "activate" and not alarmActive then
                alarmActive = true
                modem.transmit(
                    config.receiver_frequency,
                    0, -- Broadcast
                    {key = config.secret_key, cmd = "activate"}
                )
                term.clear()
                term.setBackgroundColor(colors.red)
                print("----------------------------------")
                print("SECURITY ALERT ENABLED")
                print("Press any key to reboot security system")
                print("----------------------------------")
            end
        end
    end
end,

function()
    while true do
        local _, event = os.pullEvent("key")
        print(event)
        if _ == "key" then -- Touche Entrée
            if alarmActive then
                modem.transmit(
                    config.receiver_frequency,
                    0,
                    {key = config.secret_key, cmd = "stop"}
                )
                alarmActive = false
                print("Rebooting")
                sleep(1)
                os.reboot()
            end
        end
    end
end
)