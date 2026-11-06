--!strict
-- M2 personal Street Cubs. Every garage owner gets their own A-Chassis bike cloned from
-- ServerStorage.StreetCubTemplate (vendor model, unmodified) and parked at their plot's BikeStart.
-- Only the owner can mount it (F / RidePrompt, or touching the seat); anyone else is refused or ejected.
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local Layout = require(game:GetService("ReplicatedStorage"):WaitForChild("RaceAndRaid"):WaitForChild("HubLayout"))
local appearance = require(script.Parent.VehicleAppearance)
local riderPose = require(script.Parent.RiderPose)

local VehicleService = {}

local bikes: {[number]: Model} = {} -- ownerUserId -> bike
local homes: {[number]: CFrame} = {}

local feedback: (Player, string) -> () = function() end
function VehicleService.setFeedback(fn: (Player, string) -> ()) feedback = fn end

local function folder(): Folder
 local f = workspace:FindFirstChild("Vehicles")
 if f and f:IsA("Folder") then return f end
 local created = Instance.new("Folder")
 created.Name = "Vehicles"
 created.Parent = workspace
 return created
end

local function stop(bike: Model)
 for _, item in bike:GetDescendants() do
  if item:IsA("BasePart") then
   item.AssemblyLinearVelocity = Vector3.zero
   item.AssemblyAngularVelocity = Vector3.zero
  end
 end
end

function VehicleService.seatOf(bike: Model): VehicleSeat
 return bike:WaitForChild("DriveSeat") :: VehicleSeat
end

function VehicleService.bikeOf(userId: number): Model?
 local bike = bikes[userId]
 if bike and bike.Parent then return bike end
 return nil
end

-- Bike the player is currently riding (their own; nobody can ride another player's bike).
function VehicleService.ridden(player: Player): (Model?, VehicleSeat?)
 local character = player.Character
 local humanoid = character and character:FindFirstChildOfClass("Humanoid")
 local seat = humanoid and humanoid.SeatPart
 local bike = VehicleService.bikeOf(player.UserId)
 if seat and bike and seat:IsDescendantOf(bike) and seat:IsA("VehicleSeat") then return bike, seat end
 return nil, nil
end

-- Place a bike (and its rider, if seated) at a CFrame for the DriveSeat, at rest.
function VehicleService.placeAt(bike: Model, seatTarget: CFrame)
 local seat = VehicleService.seatOf(bike)
 bike:PivotTo(seatTarget * seat.CFrame:Inverse() * bike:GetPivot())
 stop(bike)
end

function VehicleService.returnHome(userId: number)
 local bike, home = bikes[userId], homes[userId]
 if bike and home then VehicleService.placeAt(bike, home) end
end

function VehicleService.spawn(ownerUserId: number, ownerName: string, plotId: string): Model
 VehicleService.despawn(ownerUserId)
 local template = ServerStorage:WaitForChild("StreetCubTemplate") :: Model
 local bodyTemplate = ServerStorage:WaitForChild("UnderboneBody") :: Model
 local bike = template:Clone()
 bike.Name = "StreetCub_" .. ownerUserId
 bike:SetAttribute("StreetCub", true)
 bike:SetAttribute("OwnerUserId", ownerUserId)
 bike:SetAttribute("OwnerName", ownerName)
 bike:SetAttribute("PlotId", plotId)
 local home = Layout.PlotFrame(Layout.FindPlot(plotId)) * CFrame.new(Layout.PlotLocal.BikeStart)
 homes[ownerUserId] = home
 bikes[ownerUserId] = bike
 local seat = VehicleService.seatOf(bike)
 -- Position before parenting: the vendor Initialize script welds/unanchors where the model stands.
 bike:PivotTo(home * seat.CFrame:Inverse() * bike:GetPivot())
 bike.Parent = folder()
 task.spawn(function()
  appearance.apply(bike, bodyTemplate)
  if bike.Parent then
   if not seat.Occupant then VehicleService.placeAt(bike, home) end
   riderPose.bind(bike)
  end
 end)

 local prompt = Instance.new("ProximityPrompt")
 prompt.Name = "RidePrompt"
 prompt.ActionText = "ขึ้นรถ"
 prompt.ObjectText = "Street Cub ของ " .. ownerName
 prompt.KeyboardKeyCode = Enum.KeyCode.F -- VehicleInput.Actions.Mount
 prompt.MaxActivationDistance = 9
 prompt.RequiresLineOfSight = false
 prompt.Parent = seat
 prompt:SetAttribute("OwnerUserId", ownerUserId)
 prompt.Triggered:Connect(function(player: Player)
  if player.UserId ~= ownerUserId then
   feedback(player, "นี่คือรถของ " .. ownerName .. " • ไปที่รถของคุณที่อู่ตัวเอง")
   return
  end
  local character = player.Character
  local humanoid = character and character:FindFirstChildOfClass("Humanoid")
  local root = character and character:FindFirstChild("HumanoidRootPart")
  if humanoid and root and root:IsA("BasePart") and humanoid.Health > 0 and not seat.Occupant and not seat.Disabled
   and (root.Position - seat.Position).Magnitude <= 10 then
   seat:Sit(humanoid)
  end
 end)
 seat:GetPropertyChangedSignal("Occupant"):Connect(function()
  local occupant = seat.Occupant
  prompt.Enabled = occupant == nil
  if occupant then
   local rider = Players:GetPlayerFromCharacter(occupant.Parent)
   if not rider or rider.UserId ~= ownerUserId then
    -- Touch-sit by someone else: break the server-side SeatWeld (the humanoid state is client-owned,
    -- so Sit=false alone is overridden). The weld is created after Occupant changes: defer, retry.
    if rider then feedback(rider, "นี่คือรถของ " .. ownerName) end
    task.spawn(function()
     for _ = 1, 20 do
      task.wait()
      if seat.Occupant ~= occupant then break end
      for _, w in seat:GetChildren() do
       if w.Name == "SeatWeld" and w:IsA("Weld") then w:Destroy() end
      end
     end
    end)
   end
  end
 end)
 return bike
end

function VehicleService.despawn(ownerUserId: number)
 local bike = bikes[ownerUserId]
 bikes[ownerUserId] = nil
 homes[ownerUserId] = nil
 if bike then bike:Destroy() end
end

-- Out-of-world recovery for every personal bike (lab aid, not anti-cheat).
task.spawn(function()
 while true do
  task.wait(0.25)
  for userId, bike in bikes do
   local seat = bike:FindFirstChild("DriveSeat")
   if seat and seat:IsA("BasePart") then
    local p = seat.Position
    if p.X < Layout.MinX or p.X > Layout.MaxX or math.abs(p.Z) > Layout.MaxZ or p.Y < -12 then
     VehicleService.returnHome(userId)
     workspace:SetAttribute("LabRecoveryCount", (workspace:GetAttribute("LabRecoveryCount") or 0) + 1)
    end
   end
  end
 end
end)

return VehicleService
