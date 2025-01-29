local config = dofile("alarm_config.cfg")
local modem = peripheral.find("modem") or error("Modem requis!")
modem.open(config.trigger_frequency)

while true do
    local event = os.pullEvent("redstone")
    if redstone.getInput("front") then
        modem.transmit(
            config.trigger_frequency,
            config.central_id,
            {key = config.secret_key, cmd = "activate"}
        )
        sleep(1) -- Anti-rebond
    end
end