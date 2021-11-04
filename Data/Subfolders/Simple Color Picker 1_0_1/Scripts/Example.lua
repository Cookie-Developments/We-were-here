local object_to_color = script:GetCustomProperty("object_to_color"):WaitForObject()

Events.Connect("color_picked", function(color)
	object_to_color:SetColor(color)
end)