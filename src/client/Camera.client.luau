local player = game.Players.LocalPlayer
local lighting = game:GetService("Lighting")

local colorEffect = lighting:FindFirstChild("AnxietyColor") or Instance.new("ColorCorrectionEffect")
colorEffect.Name = "AnxietyColor"
colorEffect.Parent = lighting

colorEffect.Saturation = 0
colorEffect.Contrast = 0
colorEffect.Brightness = 0

player:GetAttributeChangedSignal("AnxietyLevel"):Connect(function() 
	local level = player:GetAttribute("AnxietyLevel") or 0
	local char = player.Character
	local humanoid = char and char:FindFirstChild("Humanoid")

	
	if level > 20 then
		colorEffect.Saturation = -(level / 100) * 1.5
		colorEffect.Contrast = -(level / 100) * 0.5
		colorEffect.Brightness = -(level / 100) * 0.1
	else
		colorEffect.Saturation = 0
		colorEffect.Contrast = 0
		colorEffect.Brightness = 0
	end
	
	if level >= 100 then
		humanoid.WalkSpeed = 16
	end
end)