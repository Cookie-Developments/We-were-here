local picker = script:GetCustomProperty("picker"):WaitForObject()
local colors = script:GetCustomProperty("colors"):WaitForObject()
local propDialog = script:GetCustomProperty("Dialog"):WaitForObject()

local local_player = Game.GetLocalPlayer()
local picker_enabled = false

local_player.bindingPressedEvent:Connect(function(player, binding)
	if(binding == "ability_extra_29") then -- P
		if(picker_enabled) then
			Close()
		else
			Open()
		end
	end
end)

function Open()
	picker.visibility = Visibility.FORCE_ON
	propDialog.visibility = Visibility.FORCE_OFF
	UI.SetCursorVisible(true)
	UI.SetCanCursorInteractWithUI(true)

	Events.BroadcastToServer("color_picker_disable_player")

	picker_enabled = true
end

function Close()
	picker.visibility = Visibility.FORCE_OFF
	propDialog.visibility = Visibility.FORCE_ON
	UI.SetCursorVisible(false)
	UI.SetCanCursorInteractWithUI(false)
	
	picker_enabled = false
	
	Events.BroadcastToServer("color_picker_enable_player")
end

for i = 1, #colors:GetChildren() do
	local color = colors:GetChildren()[i]

	color.pressedEvent:Connect(function()
		Events.Broadcast("color_picked", color:GetButtonColor())
		Close()
	end)
end