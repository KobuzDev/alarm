local GITHUB_REPO = "https://raw.githubusercontent.com/KobuzDev/alarm/main/"

local role = ({...})[1]

if not role then
    print("Usage: install <role>")
    print("Roles: trigger|central|receiver")
    return
end

local valid_roles = {
    trigger = true,
    central = true,
    receiver = true
}

if not valid_roles[role] then
    print("Rôle invalide!")
    return
end

-- Télécharger le fichier de configuration
if not fs.exists("alarm_config.cfg") then
    shell.run("wget "..GITHUB_REPO.."alarm_config.cfg alarm_config.cfg")
end

-- Télécharger le script principal
local filename = role .. ".lua"
shell.run("wget "..GITHUB_REPO..filename.." /startup.lua")

print("Installation réussie pour: "..role)
print("Redémarrage dans 3 secondes...")
sleep(3)
os.reboot()