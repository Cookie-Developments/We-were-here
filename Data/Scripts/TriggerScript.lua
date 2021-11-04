local trigger = script.parent
local propSignFolder = script:GetCustomProperty("SignFolder"):WaitForObject()
local propSignText = script:GetCustomProperty("SignText")

function OnInteract(theTrigger, player)
    while Events.BroadcastToServer("SignEvent")  == BroadcastEventResultCode.EXCEEDED_RATE_LIMIT do
        Task.Wait()
    end
end

trigger.interactedEvent:Connect(OnInteract)


-- ---------------------------------------------------------------------------
-- [Function] SignEvent
-- ---------------------------------------------------------------------------

function OnSignCreated(text, location, rotation, scale, color)
    local signText = World.SpawnAsset(propSignText, {position = location, rotation = rotation, scale = scale, parent = propSignFolder})
    signText.text = text
    if color == nil then
        color = "#FFFFFFFF"
    end
    signText:SetColor(Color.FromStandardHex(color))
    signText.name = "SIGN_LOCAL_" .. text
    print("Sign created: " .. text)
end

Events.Connect("SignCreatedEvent", OnSignCreated)

-- Picked Color from Color Picker

Events.Connect("color_picked", function(color)
	-- Save Color to Custom Property
    while Events.BroadcastToServer("ColorSignEvent", color:ToStandardHex()) == BroadcastEventResultCode.EXCEEDED_RATE_LIMIT do
        Task.Wait()
    end
end)