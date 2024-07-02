local discordApiUrl = "http://localhost:3000/nickname/"
local discordWebhook = "https://discord.com/api/webhooks/1241839876253683792/g05Qn_fmGOEadK1_DOFiEg3aD2PeCjdif-RhkGO9cFoLN-Eb7o80tANMOvtTLmDs4zIG" -- Replace with your actual Discord webhook URL
local ServerName = "Server Name" -- Replace with your Server name
local footerIconUrl = "https://i.postimg.cc/N0NxHcbt/Final.png" -- Replace with your footer icon URL
RegisterServerEvent('playerConnecting')
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    deferrals.defer()
    
    local player = source -- Ensure 'source' is correctly defined in the scope
    local discordId = nil
    local id = ""

    -- Check for Discord identifier
    local identifiers = GetNumPlayerIdentifiers(player)
    for i = 0, identifiers - 1 do 
        local identifier = GetPlayerIdentifier(player, i)
        if identifier ~= nil then
            if string.match(identifier, "discord:") then
                discordId = string.sub(identifier, 9)
                id = discordId
                break
            end
        end
    end

    if discordId then
        PerformHttpRequest(discordApiUrl .. discordId, function(statusCode, response, headers)
            if statusCode == 200 then
                local data = json.decode(response)
                local discordNickname = data.nickname
                if discordNickname == name then
                    deferrals.done()
                else
                    local kickReason = string.format("Your FiveM name is %s. Please make it %s.", name, discordNickname)
                    deferrals.done(kickReason)
                    
                    -- Send a Discord webhook message for connection failure
                    local errorMessage = string.format("Player %s failed to connect. Expected name: %s\n Discord: <@%s>", name, discordNickname, id)
                    
                    local embed = {
                        {
                            ["color"] = 16711680, -- Red color
                            ["title"] = "Player Rejected from Server",
                            ["description"] = errorMessage,
                            ["footer"] = {
                                ["text"] = ServerName,
                                ["icon_url"] = footerIconUrl,
                            },
                        }
                    }
                    
                    PerformHttpRequest(discordWebhook, function() end, 'POST', json.encode({ embeds = embed }), { ['Content-Type'] = 'application/json' })
                end
            else
                deferrals.done("Error fetching Discord nickname.")
                PerformHttpRequest(discordWebhook, function() end, 'POST', json.encode({ content = "Error fetching Discord nickname." }), { ['Content-Type'] = 'application/json' })
            end
        end, 'GET', '', { })
    else
        deferrals.done("Could not find your Discord ID.")
        PerformHttpRequest(discordWebhook, function() end, 'POST', json.encode({ content = "Could not find Discord ID for player." }), { ['Content-Type'] = 'application/json' })
    end
end)
