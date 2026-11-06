-- QA-only (Studio Play Server). Pre-drive setup for one B3 case: dismount, park the Street Cub at the
-- plot's BikeStart (stationary placement BEFORE the drive) and stand the character beside it.
-- __PLOT__ = G1..G6. No placement happens while driving. Never shipped.
local L=require(game.ReplicatedStorage.RaceAndRaid.HubLayout)
local plot=L.FindPlot("__PLOT__")
local bike=(workspace:WaitForChild("Vehicles"):WaitForChild("StreetCub_"..game.Players:GetPlayers()[1].UserId)) :: Model
local seat=bike:WaitForChild("DriveSeat") :: VehicleSeat
local p=game.Players:GetPlayers()[1]
local ch=p.Character :: Model
local hum=ch:FindFirstChildOfClass("Humanoid") :: Humanoid
local root=ch:FindFirstChild("HumanoidRootPart") :: BasePart
if seat.Occupant then local w=seat:FindFirstChild("SeatWeld");if w then w:Destroy() end;hum.Sit=false;hum.Jump=true end
task.wait(.8)
local target=L.PlotFrame(plot)*CFrame.new(L.PlotLocal.BikeStart)
bike:PivotTo(target*seat.CFrame:Inverse()*bike:GetPivot())
for _,d in bike:GetDescendants() do if d:IsA("BasePart") then d.AssemblyLinearVelocity=Vector3.zero;d.AssemblyAngularVelocity=Vector3.zero end end
task.wait(1.5)
root.CFrame=seat.CFrame*CFrame.new(-4,1.5,0)
root.AssemblyLinearVelocity=Vector3.zero
task.wait(1)
return string.format("setup %s seat=(%.1f,%.1f,%.1f) occupant=%s char=%.1f",plot.id,seat.Position.X,seat.Position.Y,seat.Position.Z,tostring(seat.Occupant),(root.Position-seat.Position).Magnitude)
