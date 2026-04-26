local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local loadingScreen = ReplicatedFirst:WaitForChild("LoadingScreen"):Clone()
loadingScreen.Parent = playerGui

local frame = loadingScreen:WaitForChild("Frame")
local loadingText = frame:WaitForChild("TextLabel")
local loadingBar = frame:WaitForChild("LoadingBar")
local bar = loadingBar:WaitForChild("Bar")

local assets = game:GetChildren()

for index, asset in pairs(assets) do
    loadingText.Text = "Loading " .. asset.Name.. "..."
    ContentProvider:PreloadAsync({asset})

    local progress = index / #assets
    bar.Size = UDim2.new(progress, 0, 1, 0)
end

loadingText.Text = "Loading Complete"
bar.Size = UDim2.new(1, 0, 1, 0)

task.wait(4)
loadingScreen:Destroy()