local player = game.Players.LocalPlayer
local ui = player:WaitForChild("PlayerGui"):WaitForChild("MenuGui")
local MenuBackground = ui:WaitForChild("MenuBackground")

local originalPosition = UDim2.new(0.21, 0,-0.06, 0) 
local closedPosition = UDim2.new(0.21, 0,0.909, 0)

local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, processed)
	if processed then return end
	
	if input.KeyCode == Enum.KeyCode.M then
		if ui.MenuBackground.Visible == true then
			MenuBackground:TweenPosition(closedPosition, "Out", "Quad", 0.2, true, function()
				ui.MenuBackground.Visible = false
			end)
		else
			ui.MenuBackground.Visible = true
			MenuBackground:TweenPosition(originalPosition, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
		end
	end
end)