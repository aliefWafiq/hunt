local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local loadingScreen = ReplicatedFirst:WaitForChild("LoadingScreenGui"):Clone()
loadingScreen.Parent = playerGui

local frame = loadingScreen:WaitForChild("Frame")
local loadingInfo = frame:WaitForChild("LoadingInfo")
local loadingBar = frame:WaitForChild("LoadingBar")
local bar = loadingBar:WaitForChild("Bar")
local loadingTextTemplate = loadingScreen:WaitForChild("LoadingTextTemplate")
local listLayout = loadingInfo:WaitForChild("UIListLayout")
local nowLoading = frame:WaitForChild("NowLoading")

local assets = game:GetChildren()
loadingInfo.Visible = false

for index, asset in pairs(assets) do
    nowLoading.Text = "Downloading:  >"..asset.Name

    local loadingTextClone = loadingTextTemplate:Clone()
    loadingTextClone.Text = ">"..asset.Name
    loadingTextClone.Visible = true
    loadingTextClone.Parent = loadingInfo

    if listLayout then
        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Wait()
    end

    ContentProvider:PreloadAsync({asset})

    local progress = index / #assets
    bar.Size = UDim2.new(progress, 0, 1, 0)
end

nowLoading.Text = "All assets downloaded!"
loadingInfo.Visible = true
loadingInfo.CanvasPosition = Vector2.new(0, listLayout.AbsoluteContentSize.Y)
bar.Size = UDim2.new(1, 0, 1, 0)

task.wait(4)
loadingScreen:Destroy()