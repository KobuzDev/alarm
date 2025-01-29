local config = dofile("alarm_config.cfg")
local modem = peripheral.find("modem") or error("Modem requis!")
local alarmActive = false

modem.open(config.trigger_frequency)
modem.open(config.receiver_frequency)

print("Serveur central actif!")
print("Appuyez sur Entrée pour désactiver")

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
                print("Alarme activée!")
            end
        end
    end
end,

function()
    while true do
        local event = os.pullEvent("key")
        if event[1] == "key" and event[2] == 28 then -- Touche Entrée
            if alarmActive then
                modem.transmit(
                    config.receiver_frequency,
                    0,
                    {key = config.secret_key, cmd = "stop"}
                )
                alarmActive = false
                print("Alarme désactivée")
            end
        end
    end
end
)