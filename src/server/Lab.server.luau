--!strict
-- Engineering fixtures only; no final environment art.
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Course=require(script.Parent.CargoCourse)
-- Spawn follows the G1 PlotFrame (HubLayout is the single coordinate source).
local spawnPoint=workspace:FindFirstChild("Spawn")
if spawnPoint and spawnPoint:IsA("SpawnLocation") then spawnPoint.CFrame=require(game.ReplicatedStorage.RaceAndRaid.HubLayout).SpawnCFrame end
Course.build()
local bike = workspace:WaitForChild("ChassisTestBike") :: Model
local appearance = require(script.Parent.VehicleAppearance)
local template = game:GetService("ServerStorage"):WaitForChild("UnderboneBody") :: Model
appearance.apply(bike,template)
local driveSeat=bike:WaitForChild("DriveSeat") :: VehicleSeat
bike:PivotTo(Course.BikeStart*driveSeat.CFrame:Inverse()*bike:GetPivot())
require(script.Parent.RiderPose).bind(bike)
local seat = bike:WaitForChild("DriveSeat") :: VehicleSeat
local prompt = Instance.new("ProximityPrompt")
prompt.Name = "RidePrompt"
prompt.ActionText = "ขึ้นรถทดสอบ"
prompt.ObjectText = "Street Cub • รถทดสอบ"
prompt.MaxActivationDistance = 9
prompt.RequiresLineOfSight = false
prompt.Parent = seat
prompt.Triggered:Connect(function(player: Player)
 local character = player.Character
 local humanoid = character and character:FindFirstChildOfClass("Humanoid")
 local root = character and character:FindFirstChild("HumanoidRootPart")
 if humanoid and root and root:IsA("BasePart") and humanoid.Health > 0 and not seat.Occupant and not seat.Disabled and (root.Position-seat.Position).Magnitude <= 10 then
  seat:Sit(humanoid)
 end
end)
seat:GetPropertyChangedSignal("Occupant"):Connect(function() prompt.Enabled = seat.Occupant == nil end)
local cargo: {[Player]: string} = {}
local secured: {[Player]: number} = {}
local function initialize(player: Player)
 if player:GetAttribute("TestCargo")==nil then player:SetAttribute("TestCargo",0) end
 if player:GetAttribute("TestSecured")==nil then player:SetAttribute("TestSecured",0) end
end
Players.PlayerAdded:Connect(initialize)
for _,player in Players:GetPlayers() do initialize(player) end
local lastPickup = 0
local function feedback(player: Player, message: string)
 player:SetAttribute("CargoMessage",message)
 player:SetAttribute("CargoMessageId",(player:GetAttribute("CargoMessageId") or 0)+1)
end
local function fixture(name: string, position: Vector3, color: Color3, action: string): ProximityPrompt
 local part = Instance.new("Part")
 part.Name = name
 part.Size = Vector3.new(5, 0.05, 5)
 part.CanCollide = false
 part.Position = position + Vector3.new(0,0.33,0)
 part.Anchored = true
 part.Color = color
 part.Parent = workspace
 local p = Instance.new("ProximityPrompt")
 p.ActionText = action
 p.KeyboardKeyCode = Enum.KeyCode.F
 p.HoldDuration = 0.35
 p.ObjectText = "จุดทดสอบระบบ — Session เท่านั้น"
 p.MaxActivationDistance = 12
 p.RequiresLineOfSight = false
 p.Parent = part
 return p
end
local pickup = fixture("TestScrapPickup", Course.Pickup, Color3.fromRGB(245,184,46), "เก็บ Cargo 1 ชิ้น")
local deposit = fixture("TestGarageDeposit", Course.Deposit, Color3.fromRGB(39,197,229), "ฝาก Cargo")
local function inRange(player: Player, point: Vector3): boolean
 local occupant = seat.Occupant
 return occupant ~= nil and occupant.Parent == player.Character and occupant.Health > 0 and (seat.Position-point).Magnitude <= 14 and seat.AssemblyLinearVelocity.Magnitude <= 8
end
pickup.Triggered:Connect(function(player: Player)
 if not inRange(player, Course.Pickup) then feedback(player,"ขึ้นรถ เข้าใกล้จุด แล้วเบรกให้ช้าก่อนเก็บ");return end
 if cargo[player] then feedback(player,"Cargo เต็มแล้ว กลับไปฝากที่จุดจอด");return end
 if os.clock()-lastPickup < 2 then feedback(player,"กำลังเตรียมอะไหล่ กรุณารอสักครู่");return end
 lastPickup = os.clock()
 cargo[player] = HttpService:GenerateGUID(false)
 player:SetAttribute("TestCargo", 1)
 feedback(player,"เก็บอะไหล่แล้ว! กลับจุดจอดเพื่อฝาก Cargo")
end)
deposit.Triggered:Connect(function(player: Player)
 if not inRange(player, Course.Deposit) then feedback(player,"ขี่รถเข้าใกล้จุดฝากและเบรกให้ช้าก่อน");return end
 if not cargo[player] then feedback(player,"ยังไม่มี Cargo ไปเก็บอะไหล่ที่ลานก่อน");return end
 cargo[player] = nil -- Consume before credit; no yielding between state changes.
 secured[player] = (secured[player] or 0) + 1
 player:SetAttribute("TestCargo", 0)
 player:SetAttribute("TestSecured", secured[player])
 feedback(player,"ฝากสำเร็จ! ออกไปเก็บอะไหล่รอบถัดไปได้")
end)
Players.PlayerRemoving:Connect(function(player: Player) cargo[player]=nil; secured[player]=nil end)
workspace:SetAttribute("ProjectId", "StealAPart-Slice-01")
print("RACE & RAID chassis lab ready; no persistent economy; no visual approval")
-- Test-course recovery: explicit lab aid, not an anti-cheat implementation.
local home = bike:GetPivot()
task.spawn(function()
 while bike.Parent do
  task.wait(0.25)
  if not seat.Parent then break end
  local p = seat.Position
  if p.X < -1250 or p.X > 3800 or math.abs(p.Z)>1100 or p.Y < -12 then
   bike:PivotTo(home)
   for _, item in bike:GetDescendants() do
    if item:IsA("BasePart") then
     item.AssemblyLinearVelocity = Vector3.zero
     item.AssemblyAngularVelocity = Vector3.zero
    end
   end
   workspace:SetAttribute("LabRecoveryCount", (workspace:GetAttribute("LabRecoveryCount") or 0)+1)
  end
 end
end)