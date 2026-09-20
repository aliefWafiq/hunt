local ServerStorage = game:GetService("ServerStorage")
local ModuleFolder = ServerStorage:WaitForChild("Module")

local StuntEnemy = require(ModuleFolder:WaitForChild("StuntModule"))
local TeleportPlayers = require(ModuleFolder:WaitForChild("TeleportPlayers"))

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local emergencyMeeting = ReplicatedStorage:WaitForChild("EmergencyMeeting")
local EmergencyMeetingAnnounce = ReplicatedStorage:WaitForChild("EmergencyMeetingAnnounce")
local seatFolder = game.Workspace:WaitForChild("SeatFolder")

local EmergencyLight = game.Workspace:WaitForChild("EmergencyLight")

local VotePlayer = game.ReplicatedStorage.VotePlayer
local player = game:GetService("Players")
local isCooldown = false
local meetingDuration = 30

local VotedPlayer = game.ReplicatedStorage.VotedPlayer

local votedList = {}

local function calculateVoted()
	local votedCount = {}
	local maxVote = 0
	local winner = nil
	local draw = false

	for _, target in pairs(votedList) do
		votedCount[target] = (votedCount[target] or 0) + 1
	end

	for target, total in pairs(votedCount) do
		if total > maxVote  then
			maxVote = total
			winner = target
			draw = false
		elseif total == maxVote then
			draw = true
		end
	end

	if draw then
		VotedPlayer:FireAllClients("Draw", 0, false, true)
	else
		if winner then
			local targetPlayer = player:FindFirstChild(winner)
			local role = targetPlayer:GetAttribute("Role")

			if role == "Impostor" then
				VotedPlayer:FireAllClients(targetPlayer, maxVote, true, false)
			else
				VotedPlayer:FireAllClients(targetPlayer, maxVote, false, false)
			end
			task.wait(5)
			targetPlayer.Character.Humanoid.Health = 0
		else
			VotedPlayer:FireAllClients("Skipped", 0, false)
		end
	end

	votedList = {}
end

emergencyMeeting.OnServerEvent:Connect(function(playerTriggered)
	if isCooldown then 
		return
	else
		StuntEnemy.StuntEnemy(meetingDuration + 15)
		EmergencyMeetingAnnounce:FireAllClients()

		print("Emergency meeting triggered by: "..playerTriggered.Name	)

		isCooldown = true

		local seats = seatFolder:GetChildren()
		local allPlayers = Players:GetPlayers()

		EmergencyLight.Color = Color3.fromHex("#ff0000")

		for i, player in pairs(Players:GetPlayers()) do
			local character = player.Character
			local seat = seats[i]

			if character and seat then
				local actualSeat = seat:FindFirstChild("Seat")
				actualSeat.Disabled = false

				if actualSeat and actualSeat:IsA("Seat") then
					local humanoid = character:FindFirstChild("Humanoid")
					local hrp = character:FindFirstChild("HumanoidRootPart")

					if humanoid and hrp and not actualSeat.Occupant then
						task.spawn(function()
							hrp.CFrame = actualSeat.CFrame * CFrame.new(0, 2, 0)
							task.wait(0.1)
							actualSeat:Sit(humanoid)
						end)
					end
				end
			end
		end
		
		task.wait(meetingDuration)
		calculateVoted()
		EmergencyLight.Color = Color3.fromHex("#00ff15")
		task.wait(5)
		TeleportPlayers.TeleportPlayers()
		task.wait(30)
		isCooldown = false
	end
end)

VotePlayer.OnServerEvent:Connect(function(player, targetPlayer)
	votedList[player.Name] = targetPlayer
end)