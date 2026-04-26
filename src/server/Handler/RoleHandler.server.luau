local Players = game:GetService("Players")
local impostor = nil

Players.PlayerAdded:Connect(function()
	local AllPlayers = Players:GetPlayers()
	
	if #AllPlayers >= 0 and impostor == nil  then
		impostor = AllPlayers[math.random(1, #AllPlayers)]
		impostor:SetAttribute("Role", "Impostor")
	end
end)