local DISCORD_BOT_TOKEN = ""
local GUILD_ID = ""
local WEBHOOK_URL = ""

local function log(message)
    local data = {
        ["content"] = "[Discord Check]: " .. message,
        ["username"] = "PRR Discord Name Check",
    }
    PerformHttpRequest(WEBHOOK_URL, function(err, text, headers) end, 'POST', json.encode(data), {['Content-Type'] = 'application/json'})
end

local function getDiscordIdFromIdentifiers(identifiers)
    for _, identifier in pairs(identifiers) do
        if string.match(identifier, "discord:") then
            return string.sub(identifier, 9) -- Extract Discord ID
        end
    end
    return nil
end

local function handlePlayerConnecting(name, deferrals, discordId)
    local endpoint = string.format("https://discord.com/api/guilds/%s/members/%s", GUILD_ID, discordId)
    PerformHttpRequest(endpoint, function(statusCode, response)
        if statusCode == 200 then
            local data = json.decode(response)
            local discordNickname = data.nick or data.user.username
            if discordNickname == name then
                deferrals.done()
            else
                deferrals.done(string.format("Your FiveM name is %s. Please make it %s.", name, discordNickname))
            end
        else
            log("Failed to fetch Discord nickname, status code: " .. statusCode)
            deferrals.done("Error fetching Discord nickname.")
        end
    end, "GET", "", {["Authorization"] = "Bot " .. DISCORD_BOT_TOKEN})
end

RegisterServerEvent("playerConnecting")
AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    deferrals.defer()
    local player = source
    local identifiers = GetPlayerIdentifiers(player)
    local discordId = getDiscordIdFromIdentifiers(identifiers)

    if discordId then
        handlePlayerConnecting(name, deferrals, discordId)
    else
        log("Discord ID not found for player: " .. name)
        deferrals.done("Could not find your Discord ID.")
    end
end)