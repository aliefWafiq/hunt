local ProximityPromptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")
local player =  game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local customUi = playerGui:WaitForChild("CustomPromptUi")
local icon = customUi:FindFirstChildWhichIsA("ImageLabel")

local function showUI(prompt)
	customUi.Adornee = prompt.Parent
	customUi.Enabled = true
	
	icon.Size = UDim2.new(0, 0, 0, 0)
	local tween = TweenService:Create(icon, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
		Size = UDim2.new(1, 0, 1, 0)
	})
	tween:Play()
end

ProximityPromptService.PromptShown:Connect(function(prompt)
	if prompt.Style == Enum.ProximityPromptStyle.Custom  then
		showUI(prompt)
	end
end)

ProximityPromptService.PromptHidden:Connect(function(prompt)
	customUi.Enabled = false
end)