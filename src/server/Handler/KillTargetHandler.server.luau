local KillTarget = game.ReplicatedStorage:WaitForChild("KillTarget")
local Players = game:GetService("Players")

KillTarget.OnServerEvent:Connect(function(player, target)
	local character = target.Character
	local hrp = character:FindFirstChild("HumanoidRootPart")
	
	for _, model in pairs(game.Workspace:GetChildren()) do
		if model:IsA("Model") and model.Name == "chago" then
			local chagoCharacter = model
			local chagoHumanoid = chagoCharacter:FindFirstChild("Humanoid")
			local chagoHrp = chagoCharacter:FindFirstChild("HumanoidRootPart")
			
			if chagoHumanoid and chagoHrp then
				chagoHrp.CFrame = hrp.CFrame 
			end
		end
	end
	
	--humanoid.Health = 0
end)