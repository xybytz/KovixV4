local LocalPlayer = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local InventoryUtil = require(ReplicatedStorage.TS.inventory["inventory-util"]).InventoryUtil

Player = ""
local function GetInventory()
	for i,v in pairs(game:FindService("Players"):GetPlayers()) do

		local Inventory = InventoryUtil.getInventory(v)

		return Inventory
	end
end
local function HasItem(Name)
	for i, v in next, GetInventory().items do
		if v.itemType:find(Name) then
			return v
		end
	end	

	return nil
end

local ResetCharacterRemote = ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged"):WaitForChild("ResetCharacter")


local function KillHumanoid(Time)
	local Time = 0

	LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
	
	ResetCharacterRemote:FireServer()
end
local function IsAlive()
	Player = LocalPlayer

	if not Player.Character then return false end
	if not Player.Character:FindFirstChild("Humanoid") then return false end
	if Player.Character:GetAttribute("Health") <= 0 then return false end
	if not Player.Character.PrimaryPart then return false end	

	return true
end	
local function TweenToNearestPlayer(player)
	local Time = 0.65
	
	if IsAlive() then
		local NearestPlayer = player

		if NearestPlayer then
			local TweenInformation = TweenInfo.new(Time, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0)	
			local PlayerTpTween = TweenService:Create(LocalPlayer.Character.PrimaryPart, TweenInformation, {CFrame = NearestPlayer.Character.PrimaryPart.CFrame + Vector3.new(0, 2, 0)})

			PlayerTpTween:Play()
		end
	end
end

local function sniper()
	for i,v in pairs(game:FindService("Players"):GetPlayers()) do

    	if HasItem("emerald") then
        	KillHumanoid(0)
        	LocalPlayer.CharacterAdded:Connect(function()
            	repeat task.wait() until IsAlive()

            	if IsAlive() == true then
                	task.wait(0.15)
                	TweenToNearestPlayer(v.Character.PrimaryPart.CFrame)
				end
			end)
                
            end
        end
    end
sniper()
