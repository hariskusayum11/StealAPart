--!strict
-- Server bootstrap: world build, M2 garage ownership + personal Street Cubs, legacy Cargo fixtures.
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Layout = require(game.ReplicatedStorage.RaceAndRaid.HubLayout)
local Course = require(script.Parent.CargoCourse)
local Garage = require(script.Parent.GarageService)
local Vehicles = require(script.Parent.VehicleService)

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

local function placeAtGarage(player: Player, character: Model)
 local plotId = Garage.plotOf(player.UserId)
 if not plotId then return end
 task.defer(function()
  if character.Parent then character:PivotTo(Garage.spawnCFrame(plotId)) end
 end)
end

local cargo: {[Player]: string} = {}
local secured: {[Player]: number} = {}

local function onPlayerAdded(player: Player)
 if player:GetAttribute("TestCargo") == nil then player:SetAttribute("TestCargo", 0) end
 if player:GetAttribute("TestSecured") == nil then player:SetAttribute("TestSecured", 0) end
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
 cargo[player] = nil
 secured[player] = nil
 Vehicles.despawn(player.UserId)
 Garage.release(player.UserId)
end)

-- Legacy Cargo fixtures (replaced by the Raid Gate deposit in M5).
local lastPickup: {[Player]: number} = {}
local function fixture(name: string, position: Vector3, color: Color3, action: string): ProximityPrompt
 local part = Instance.new("Part")
 part.Name = name
 part.Size = Vector3.new(5, 0.05, 5)
 part.CanCollide = false
 part.Position = position + Vector3.new(0, 0.33, 0)
 part.Anchored = true
 part.Color = color
 part.Parent = workspace
 local p = Instance.new("ProximityPrompt")
 p.ActionText = action
 p.KeyboardKeyCode = Enum.KeyCode.E -- VehicleInput.Actions.Pickup
 p.HoldDuration = 0.35
 p.ObjectText = "จุดทดสอบระบบ — Session เท่านั้น"
 p.MaxActivationDistance = 12
 p.RequiresLineOfSight = false
 p.Parent = part
 return p
end
local pickup = fixture("TestScrapPickup", Course.Pickup, Color3.fromRGB(245, 184, 46), "เก็บ Cargo 1 ชิ้น")
local deposit = fixture("TestGarageDeposit", Course.Deposit, Color3.fromRGB(39, 197, 229), "ฝาก Cargo")
local function inRange(player: Player, point: Vector3): boolean
 local _, seat = Vehicles.ridden(player)
 return seat ~= nil and (seat.Position - point).Magnitude <= 14 and seat.AssemblyLinearVelocity.Magnitude <= 8
end
pickup.Triggered:Connect(function(player: Player)
 if not inRange(player, Course.Pickup) then feedback(player, "ขึ้นรถ เข้าใกล้จุด แล้วเบรกให้ช้าก่อนเก็บ"); return end
 if cargo[player] then feedback(player, "Cargo เต็มแล้ว กลับไปฝากที่จุดจอด"); return end
 if os.clock() - (lastPickup[player] or 0) < 2 then feedback(player, "กำลังเตรียมอะไหล่ กรุณารอสักครู่"); return end
 lastPickup[player] = os.clock()
 cargo[player] = HttpService:GenerateGUID(false)
 player:SetAttribute("TestCargo", 1)
 feedback(player, "เก็บอะไหล่แล้ว! กลับจุดจอดเพื่อฝาก Cargo")
end)
deposit.Triggered:Connect(function(player: Player)
 if not inRange(player, Course.Deposit) then feedback(player, "ขี่รถเข้าใกล้จุดฝากและเบรกให้ช้าก่อน"); return end
 if not cargo[player] then feedback(player, "ยังไม่มี Cargo ไปเก็บอะไหล่ที่ลานก่อน"); return end
 cargo[player] = nil -- Consume before credit; no yielding between state changes.
 secured[player] = (secured[player] or 0) + 1
 player:SetAttribute("TestCargo", 0)
 player:SetAttribute("TestSecured", secured[player])
 feedback(player, "ฝากสำเร็จ! ออกไปเก็บอะไหล่รอบถัดไปได้")
end)
-- Studio-only QA hook (ServerStorage never replicates; not created in live servers): lets the
-- multiplayer suite drive the real module instances with mock owners.
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
  return nil
 end
 hook.Parent = game:GetService("ServerStorage")
end
workspace:SetAttribute("ProjectId", "StealAPart-Slice-01")
print("STEAL A PART! server ready: session garages + personal Street Cubs; no persistent economy")
