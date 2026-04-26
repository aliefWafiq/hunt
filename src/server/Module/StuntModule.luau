local StuntModule = {}

function StuntModule.StuntEnemy(stuntDuration)
	local stuntAnim = "rbxassetid://125204084548596"
	local walkAnim = "rbxassetid://180426354"
	local stuntAnimTrack = nil 
	
	for _, obj in pairs(game.Workspace:GetChildren()) do
		if obj:IsA("Model") and obj.Name == "chago" then
			local hrp = obj:FindFirstChild("HumanoidRootPart")

			if hrp then
				hrp.Anchored = true
				local newAnim = Instance.new("Animation")
				newAnim.AnimationId = stuntAnim
				stuntAnimTrack = obj:FindFirstChild("Humanoid"):LoadAnimation(newAnim)
				stuntAnimTrack:Play(0.3)

				task.delay(stuntDuration, function()
					if hrp then hrp.Anchored = false end
					if stuntAnimTrack then
						stuntAnimTrack:Stop(0.3)
					end
				end)
			end
		end
	end
end

return StuntModule
