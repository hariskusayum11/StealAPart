--!strict
-- Server bootstrap: world build, garages + personal Street Cubs (M2), Raid Gate/round (M4),
-- Session only; no persistent economy. (Parts/Inventory M5 and guards M6 are wired in later.)
local Players = game:GetService("Players")
local Layout = require(game.ReplicatedStorage.RaceAndRaid.HubLayout)
local Course = require(script.Parent.CargoCourse)
local Garage = require(script.Parent.GarageService)
local Vehicles = require(script.Parent.VehicleService)
local Raid = require(script.Parent.RaidService)

-- Players without a garage (7th player) spawn at the Central Plaza; owners are moved to their plot.
local spawnPoint = workspace:FindFirstChild("Spawn")
if spawnPoint and spawnPoint:IsA("SpawnLocation") then
 spawnPoint.CFrame = CFrame.new(Layout.City.CentralPlaza + Vector3.new(0, 3, 0))
end
Course.build()
-- The vendor bike mapped into Workspace by older place files is not used any more.
local legacy = workspace:FindFirstChild("ChassisTestBike")
if legacy then legacy:Destroy() end

local function feedback(player: Player, message: string)
 player:SetAttribute("CargoMessage", message)
 player:SetAttribute("CargoMessageId", (player:GetAttribute("CargoMessageId") or 0) + 1)
end
Vehicles.setFeedback(feedback)
Raid.setFeedback(feedback)

local function placeAtGarage(player: Player, character: Model)
 local plotId = Garage.plotOf(player.UserId)
 if not plotId then return end
 task.defer(function()
  if character.Parent then character:PivotTo(Garage.spawnCFrame(plotId)) end
 end)
end

local function onPlayerAdded(player: Player)
 local plotId = Garage.assign({UserId = player.UserId, Name = player.DisplayName})
 player:SetAttribute("PlotId", plotId or "")
 if plotId then
  Vehicles.spawn(player.UserId, player.DisplayName, plotId)
 else
  feedback(player, "อู่เต็มทั้ง 6 หลัง • รอผู้เล่นออกเพื่อรับอู่")
 end
 player.CharacterAdded:Connect(function(character) placeAtGarage(player, character) end)
 if player.Character then placeAtGarage(player, player.Character) end
end
Players.PlayerAdded:Connect(onPlayerAdded)
for _, player in Players:GetPlayers() do task.spawn(onPlayerAdded, player) end
Players.PlayerRemoving:Connect(function(player: Player)
 Vehicles.despawn(player.UserId)
 Garage.release(player.UserId)
end)

Raid.start()

-- Studio-only QA hook (ServerStorage never replicates; not created in live servers): lets the
-- QA suites drive the real module instances (mock owners, short rounds, state snapshots).
if game:GetService("RunService"):IsStudio() then
 local hook = Instance.new("BindableFunction")
 hook.Name = "QAHook"
 hook.OnInvoke = function(command: string, ...: any): any
  local args = {...}
  if command == "assign" then return Garage.assign({UserId = args[1], Name = args[2]}) end
  if command == "release" then Garage.release(args[1]); return true end
  if command == "snapshot" then return Garage.snapshot() end
  if command == "spawnBike" then return Vehicles.spawn(args[1], args[2], args[3]):GetFullName() end
  if command == "despawn" then Vehicles.despawn(args[1]); return true end
  if command == "raidDurations" then Raid.qaSetDurations(args[1], args[2]); return true end
  if command == "raidAdvance" then Raid.qaAdvance(); return Raid.phase() end
  if command == "placeBike" then -- (userId, Vector3 seat position, Vector3 look direction) at rest
   local bike = Vehicles.bikeOf(args[1]); if not bike then return false end
   Vehicles.placeAt(bike, CFrame.lookAt(args[2], args[2] + args[3])); return true
  end
  if command == "sit" then -- seat a player on their own bike
   local player = Players:GetPlayerByUserId(args[1]); local bike = Vehicles.bikeOf(args[1])
   local humanoid = player and player.Character and player.Character:FindFirstChildOfClass("Humanoid")
   if bike and humanoid then Vehicles.seatOf(bike):Sit(humanoid); return true end
   return false
  end
  return nil
 end
 hook.Parent = game:GetService("ServerStorage")
end
workspace:SetAttribute("ProjectId", "StealAPart-Slice-01")
print("STEAL A PART! server ready: garages, personal Street Cubs, Raid Gate rounds, shared parts, guards")
