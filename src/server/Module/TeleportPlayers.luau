local TeleportPlayers = {}

TeleportPlayers.TeleportPlayers = function()
	local TeleportAfter = game.Workspace:WaitForChild("TeleportAfter")
	local player = game:GetService("Players")
	
	for _, player in pairs(player:GetPlayers()) do
		local character = player.Character
		local humanoid = character:WaitForChild("Humanoid")
		local hrp = character:WaitForChild("HumanoidRootPart")
		
		if hrp then
			humanoid.Sit = false
			task.wait(0.1)
			hrp.CFrame = TeleportAfter.CFrame * CFrame.new(0, 5, 0)
		end
	end
end

return TeleportPlayers
