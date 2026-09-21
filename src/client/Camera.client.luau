-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local EmergencyMeetingAnnounce = ReplicatedStorage:WaitForChild("EmergencyMeetingAnnounce")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local Labirin = workspace:WaitForChild("Labirin")
local CamProp = Labirin:WaitForChild("CamProp")

camera.CameraType = Enum.CameraType.Scriptable

local lookCamera = false
local currentCamPart = nil

-- if EmergencyMeetingAnnounce then
-- 	EmergencyMeetingAnnounce.OnClientEvent:Connect(function()
-- 		lookCamera = false
-- 		currentCamPart = nil

-- 		RunService.RenderStepped:Disconnect() -- lanjut buat fix camera waktu emergency meeting
-- 	end)
-- end

local function setupTrigger(triggerPart)
	if not triggerPart:IsA("BasePart") then return end
	if not triggerPart.Name:match("^Trigger%d+$") then return end
	local index = triggerPart.Name:match("%d+$")

	task.spawn(function() 
		local camPart = CamProp:WaitForChild("CamPoint" .. index, 10)
		if not camPart then return end

		triggerPart.Touched:Connect(function(hit)
			local character = hit.Parent
			local humanoid = character and character:FindFirstChild("Humanoid")
			if humanoid and character == player.Character then
				lookCamera = true
				currentCamPart = camPart
			end
		end)
	end)
end

for _, child in ipairs(CamProp:GetChildren()) do
	setupTrigger(child)
end
CamProp.ChildAdded:Connect(setupTrigger)

RunService.RenderStepped:Connect(function()
	if lookCamera and currentCamPart then
		camera.CFrame = currentCamPart.CFrame
	end
end)