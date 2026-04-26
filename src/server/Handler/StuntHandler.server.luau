local StuntEnemy = require(game.ServerStorage.Module.StuntModule)
local StuntEvent = game.ReplicatedStorage:WaitForChild("StuntEvent")

StuntEvent.OnServerEvent:Connect(function(player, stuntDuration)
	StuntEnemy.StuntEnemy(stuntDuration)
end)