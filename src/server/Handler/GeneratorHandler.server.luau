local ReplicatedStorage = game:GetService("ReplicatedStorage")
local door = workspace:WaitForChild("ExitDoor")

local taskRequired = 2
local taskFixed = 0

local TaskCompleted = ReplicatedStorage:WaitForChild("CompletedTask")
local GeneratorFixed = ReplicatedStorage:WaitForChild("GeneratorFixed")
local SabotageTarget = ReplicatedStorage:WaitForChild("SabotageTarget")

GeneratorFixed.OnServerEvent:Connect(function(player, task)
	local taskProp = workspace:FindFirstChild(task)
	
	print(task)
	taskProp:SetAttribute("Fixed", true)
	taskFixed += 1
	print("ATTR TRUE")
		
	print("BERHASIL")
	print("TASK FINISHED")
	print(taskFixed)
		
	TaskCompleted:FireAllClients(taskProp)

	if taskFixed >= taskRequired then
		door.CanCollide = false
		door.Transparency = 0.5

		door.Position = door.Position + Vector3.new(0, 10, 0)
		--TaskCompleted:FireAllClients(taskProp)
		print("COMPLETE")
	end
end)

SabotageTarget.OnServerEvent:Connect(function(player, task)
	taskFixed -= 1
	task:SetAttribute("Fixed", false)
	print("SET ATTR KE FALSE")
	
	SabotageTarget:FireAllClients(task)
end)