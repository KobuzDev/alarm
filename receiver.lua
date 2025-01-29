local config = dofile("alarm_config.cfg")
local modem = peripheral.find("modem") or error("Modem required")
modem.open(config.receiver_frequency)

print("---------------------------")
print("| CIUCCAD SECURITY SYSTEM |")
print("---------------------------")
print("- Receiver ready")

while true do
    local _, freq, reply, msg = os.pullEvent("modem_message")
    if freq == config.receiver_frequency and msg.key == config.secret_key then
        if msg.cmd == "activate" then
            redstone.setOutput("back", true)
        elseif msg.cmd == "stop" then
            redstone.setOutput("back", false)
        end
    end
end