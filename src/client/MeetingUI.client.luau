local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local timer = 35

local EmergencyMeetingAnnounce = ReplicatedStorage:WaitForChild("EmergencyMeetingAnnounce")
local VotePlayer = ReplicatedStorage:WaitForChild("VotePlayer")

local VotedPlayer = ReplicatedStorage:WaitForChild("VotedPlayer")

EmergencyMeetingAnnounce.OnClientEvent:Connect(function()
	local CamPart = ReplicatedStorage:FindFirstChild("camPart"):Clone()
	local introPart = workspace.Labirin:WaitForChild("introPart")

	CamPart.Parent = workspace.Labirin
	CamPart.CFrame = introPart.CFrame
	camera.CameraSubject = CamPart
	camera.CameraType = Enum.CameraType.Scriptable

	local moveFactor = 0.0005
	local previousMouseX, previousMouseY = 0, 0
	local MAX_POSITION = 0.5
	local originalPosition = CamPart.Position

	local targetPosition = originalPosition
	local moving = false

	local UI = ReplicatedStorage:FindFirstChild("VoteUi"):Clone()
	UI.Parent = workspace.Labirin

	local frame = UI
	local secondMenu = frame.Vote.SurfaceGui.Frame

	local scrollingFrame = frame.Players.SurfaceGui.ScrollingFrame
	local template = scrollingFrame.UIListLayout.PlayerTemplate

	local timerGui = secondMenu.Timer

	RunService.RenderStepped:Connect(function()
		local mouse = player:GetMouse()

		local screenX = camera.ViewportSize.X
		local screenY = camera.ViewportSize.Y

		local leftoverScreenX = screenX - mouse.X
		local leftoverScreenY = screenY - mouse.Y

		local DistanceFromOriginX = (screenX / 2) - leftoverScreenX
		local DistanceFromOriginY = leftoverScreenY - (screenY / 2)

		local clampedX = math.clamp(DistanceFromOriginX * moveFactor, -MAX_POSITION, MAX_POSITION)
		local clampedY = math.clamp(DistanceFromOriginY * moveFactor, -MAX_POSITION, MAX_POSITION)

		if previousMouseX and previousMouseY then
			local mouseMoved = (DistanceFromOriginX ~= previousMouseX) or (DistanceFromOriginY ~= previousMouseY)
			if mouseMoved then
				moving = true
				targetPosition = originalPosition + Vector3.new(clampedX, clampedY, 0)
			else
				moving = false
			end

			if moving then
				CamPart.CFrame = CamPart.CFrame:Lerp(CFrame.new(targetPosition) * introPart.CFrame.Rotation, 0.1)
			else
				CamPart.CFrame = CamPart.CFrame:Lerp(CFrame.new(targetPosition) * introPart.CFrame.Rotation, 0.2)
			end

			camera.CFrame = camera.CFrame:Lerp(CamPart.CFrame, 0.2)

			local localOffset = Vector3.new(0, 0, -15)
			local finalTargetPosition = CamPart.CFrame * CFrame.new(localOffset)

			if UI.PrimaryPart then
				UI:SetPrimaryPartCFrame(
					finalTargetPosition * CFrame.Angles(0, math.rad(23), 0)
				)
			end

			previousMouseX = DistanceFromOriginX
			previousMouseY = DistanceFromOriginY
		end
	end)

	for _, child in pairs(scrollingFrame:GetChildren()) do
		if child:IsA("TextButton") and child.Name ~= "PlayerTemplate" then
			child:Destroy()
		end
	end

	task.spawn(function()
		for i = timer, 0, -1 do
			timerGui.Text = "Voting time: " .. i
			task.wait(1)
		end
	end)

	for _, player in pairs(Players:GetPlayers()) do
		local clone = template:Clone()
		clone.Name = player.Name
		clone.Username.Text = player.Name

		local content, isReady = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

		clone.PlayerIcon.Image = content
		clone.Parent = scrollingFrame
		clone.Visible = true

		clone.MouseButton1Click:Connect(function()
			for _, otherButtons in pairs(scrollingFrame:GetChildren()) do
				if otherButtons:IsA("TextButton") and otherButtons:FindFirstChild("Select") then
					otherButtons.Select.Visible = false
				end
			end

			clone.Select.Visible = true
			clone.Interactable = false
			VotePlayer:FireServer(player.Name)
		end)
	end
end)

VotedPlayer.OnClientEvent:Connect(function(player, voteCount, isImpostor, draw)
	local frame = workspace.Labirin:WaitForChild("VoteUi")
	local votedPlayerGui = frame.Vote.SurfaceGui.Frame.VotedPlayerGui

	votedPlayerGui.Visible = true
	if player.Name == nil then
		votedPlayerGui.Username.Text = "No one voted"
		votedPlayerGui.PlayerIcon.Transparency = 1
		votedPlayerGui.TotalVote.Transparency = 1
		return
	elseif draw then
		votedPlayerGui.Username.Text = "Draw"
		votedPlayerGui.PlayerIcon.Transparency = 1
		votedPlayerGui.TotalVote.Transparency = 1
		return
	else
		local content, isReady = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

		votedPlayerGui.PlayerIcon.Image = content
		votedPlayerGui.TotalVote.Text = "Vote total: " .. voteCount
		votedPlayerGui.Username.Text = player.Name
	end
end)