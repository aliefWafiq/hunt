local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local stamina = 100
local sprinting = false

local ui = player:WaitForChild("PlayerGui"):WaitForChild("StaminaGui")
local staminaBar = ui:WaitForChild("StaminaBackground"):WaitForChild("StaminaBar")

local sprintAnim = "rbxassetid://105208385290173"
local walkAnim = "rbxassetid://117435297414526"

local sprintAnimTrack = nil 

local function startSprint()
	if stamina > 10 and not sprinting then
		humanoid.WalkSpeed = 24
		sprinting = true

		if not sprintAnimTrack then
			local newAnim = Instance.new("Animation")
			newAnim.AnimationId = sprintAnim
			sprintAnimTrack = humanoid:LoadAnimation(newAnim)

			sprintAnimTrack.Priority = Enum.AnimationPriority.Action 
		end

		sprintAnimTrack:Play(0.3)
	end
end

local function stopSprint()
	if sprinting then
		humanoid.WalkSpeed = 10
		sprinting = false

		if sprintAnimTrack then
			sprintAnimTrack:Stop(0.3)
		end
	end
end

local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.LeftShift then
		startSprint()
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then
		stopSprint()
	end
end)

game:GetService("RunService").RenderStepped:Connect(function()
	if sprinting and stamina > 0 then
		stamina = stamina - 0.30
	elseif not sprinting and stamina < 100 then
		stamina = stamina + 0.25
	end
	
	if stamina <= 0 then
		stopSprint()
	end
	
	staminaBar:TweenSize(UDim2.new(stamina / 100, 0, 1, 0), "Out", "Quad", 0.2, true)
end)