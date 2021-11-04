local propLeaderboard = script:GetCustomProperty("leaderboard")

-- Signs
local signs = {}
local colors = {}
local setupFinished = false


math.randomseed(os.time())
function OnSignCreated(player)
    local playerPos = player:GetWorldPosition()
    local randomRot = math.ceil(math.random() * 360)
    local randomScale = math.random() + 0.6

    local location = Vector3.New(playerPos.x, playerPos.y, -44.9)
    local rotation = Rotation.New(0, 90, randomRot)
    local scale = Vector3.New(randomScale, randomScale, randomScale)

    local signStorage = signs[player.name]
    local color = colors[player.name] or "#FFFFFF"

    if not signStorage then
        signStorage = {}
    end
    table.insert(signStorage, 1, {position = location, rotation = rotation, scale = scale, color = color})
    
    signs[player.name] = signStorage
    while Events.BroadcastToAllPlayers("SignCreatedEvent", player.name, location, rotation, scale, color) == BroadcastEventResultCode.EXCEEDED_RATE_LIMIT do
        Task.Wait()
    end
end

Events.ConnectForPlayer("SignEvent", OnSignCreated)

function OnPlayerJoined(player)
    -- Send all Signs to the player
    if setupFinished == false then
        print("Not ready yet")
        return
    end

    print("Sending signs to " .. player.name)
    for playerName, signStorage in pairs(signs) do
        print("Sending sign of " .. playerName)
        for i = 1, #signStorage do
            local sign = signStorage[i]
            while Events.BroadcastToPlayer(player, "SignCreatedEvent", playerName, sign.position, sign.rotation, sign.scale, sign.color) == BroadcastEventResultCode.EXCEEDED_RATE_LIMIT do
                print("Sign rate limit exceeded for " .. playerName .."'s sign. Trying again")
                Task.Wait(0.1)
            end
        end
    end
end

Game.playerJoinedEvent:Connect(function(player)
    Task.Wait(1)
    OnPlayerJoined(player)
end)

function OnPlayerLeave(player)
    -- Save PlayerSign to Leaderboard and Storage
    local playerSign = signs[player.name]
    if playerSign then
        Storage.SetPlayerData(player, playerSign)
        if (Leaderboards.HasLeaderboards()) then
            Leaderboards.SubmitPlayerScore(propLeaderboard, player, 1)
        end
    end
end

Game.playerLeftEvent:Connect(OnPlayerLeave)



function ChangeColorEvent(player, color)
    colors[player.name] = color
    print("Color changed to " .. color .. " for " .. player.name)
end

Events.ConnectForPlayer("ColorSignEvent", ChangeColorEvent)


function SendAll()
    if #Game.GetPlayers() > 0 then
        for playerName, signStorage in pairs(signs) do
            print("Sending sign of " .. playerName)
            for i = 1, #signStorage do
                local sign = signStorage[i]
                while Events.BroadcastToAllPlayers("SignCreatedEvent", playerName, sign.position, sign.rotation, sign.scale, sign.color) == BroadcastEventResultCode.EXCEEDED_RATE_LIMIT do
                    print("Sign rate limit exceeded for " .. playerName .."'s sign. Trying again")
                    Task.Wait(0.1)
                end
            end
        end
    end
end

 -- StartUP

function StartUp() 
    print("Initializing Signs")
    while not Leaderboards.HasLeaderboards() do -- just keep checking until this until the Leaderboards are loaded
        Task.Wait(1) -- wait one second
    end

    local leaderboard = Leaderboards.GetLeaderboard(propLeaderboard, LeaderboardType.GLOBAL)
    for _, entry in ipairs(leaderboard) do
        local signStorage = Storage.GetOfflinePlayerData(entry.id)
        if signStorage then
            signs[entry.name] = signStorage
        end
    end 
    setupFinished = true
    SendAll()
    print("Signs initialized")
end

StartUp()