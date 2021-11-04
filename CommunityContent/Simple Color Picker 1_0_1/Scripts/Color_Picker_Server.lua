-- For the example the controls and camera are disabled, but you might
-- want to handle this else where in your game.

Events.ConnectForPlayer("color_picker_enable_player", function(player)
	player.movementControlMode = MovementControlMode.VIEW_RELATIVE
	player.lookControlMode = LookControlMode.RELATIVE
end)

Events.ConnectForPlayer("color_picker_disable_player", function(player)
	player.movementControlMode = MovementControlMode.NONE
	player.lookControlMode = LookControlMode.NONE
end)