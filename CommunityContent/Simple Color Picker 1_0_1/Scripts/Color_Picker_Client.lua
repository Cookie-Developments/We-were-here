local picker = script:GetCustomProperty("picker"):WaitForObject()
local colors = script:GetCustomProperty("colors"):WaitForObject()

local local_player = Game.GetLocalPlayer()
local picker_enabled = false

local_player.bindingPressedEvent:Connect(function(player, binding)
	if(binding == "ability_extra_29") then -- P
		if(picker_enabled) then
			picker.visibility = Visibility.FORCE_OFF
			UI.SetCursorVisible(false)
			UI.SetCanCursorInteractWithUI(false)
			
			picker_enabled = false
			
			Events.BroadcastToServer("color_picker_enable_player")
		else
			picker.visibility = Visibility.FORCE_ON
			UI.SetCursorVisible(true)
			UI.SetCanCursorInteractWithUI(true)

			Events.BroadcastToServer("color_picker_disable_player")

			picker_enabled = true
		end
	end
end)

for i = 1, #colors:GetChildren() do
	local color = colors:GetChildren()[i]

	color.pressedEvent:Connect(function()
		Events.Broadcast("color_picked", color:GetButtonColor())
	end)
end