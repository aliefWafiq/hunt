local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local ui = player:WaitForChild("PlayerGui"):WaitForChild("ImpostorSkill")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SabotageTarget = ReplicatedStorage:WaitForChild("SabotageTarget")
local TaskFixed = ReplicatedStorage:WaitForChild("CompletedTask")
local Workspace = game:GetService("Workspace")

local tasks = {}
local removeTask = nil

local cooldown = 30
local isKillCooldown = false
local isSabotageCooldown = false

TaskFixed.OnClientEvent:Connect(function(task)
	table.insert(tasks, task)
end)

uis.InputBegan:Connect(function(input, processed)
	if player:GetAttribute("Role") ~= "Impostor" then return end
	if processed then return end

	if input.KeyCode == Enum.KeyCode.T then
		if not ui.Enabled and isKillCooldown then 
			return 
		end

		ui.Enabled = not ui.Enabled

		if ui.Enabled then
			isKillCooldown = true
			task.spawn(function()
				task.wait(cooldown)
				isKillCooldown = false
			end)
		end
		
	elseif input.KeyCode == Enum.KeyCode.Y then
		if not ui.Enabled and isSabotageCooldown then
			return
		end
		
		if #tasks == 0 then
			print("BELUM ADA YANG SELESAI")
		else
			local randomTask = math.random(1, #tasks)
			removeTask = tasks[randomTask]
			table.remove(tasks, math.random(1, randomTask))
			SabotageTarget:FireServer(removeTask)
		end
		
		isSabotageCooldown = true
		task.spawn(function()
			task.wait(cooldown)
			isSabotageCooldown = false
		end)
	end
end)