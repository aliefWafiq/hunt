local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

local function updateCharacterRotation()
    local character = player.Character
    if not character then return end

    local humanoid = character:FindFirstChild("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end

    local unitRay = camera:ScreenPointToRay(mouse.X, mouse.Y)

    local planeY = hrp.Position.Y
    local rayOrigin = unitRay.Origin
    local rayDirection = unitRay.Direction

    if rayDirection.Y == 0 then return end
    local t = (planeY - rayOrigin.Y) / rayDirection.Y
    if t < 0 then return end

    local targetPosition = rayOrigin + rayDirection * t

    local lookPos = Vector3.new(targetPosition.X, hrp.Position.Y, targetPosition.Z)
    hrp.CFrame = CFrame.new(hrp.Position, lookPos)
end

RunService.RenderStepped:Connect(function()
    updateCharacterRotation()
end)