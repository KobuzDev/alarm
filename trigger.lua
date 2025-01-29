local config = dofile("alarm_config.cfg")
local modem = peripheral.find("modem") or error("Modem required")
modem.open(config.trigger_frequency)

term.clear()
print("---------------------------")
print("| CIUCCAD SECURITY SYSTEM |")
print("---------------------------")
print("- Trigger ready")

while true do
    local event = os.pullEvent("redstone")
    if redstone.getInput("back") then
        print("Alarm activated.")
        modem.transmit(
            config.trigger_frequency,
            config.central_id,
            {key = config.secret_key, cmd = "activate"}
        )
        sleep(1) -- Anti-rebond
    end
end