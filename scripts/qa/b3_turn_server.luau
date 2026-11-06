-- PLAY-ONLY measurement setup (discarded on Stop). Places bike once before the test; no in-drive teleport.
local Players=game:GetService("Players")
local p=Players:GetPlayers()[1] or Players.PlayerAdded:Wait()
local ch=p.Character or p.CharacterAdded:Wait()
local hum=ch:WaitForChild("Humanoid") :: Humanoid
local root=ch:WaitForChild("HumanoidRootPart") :: BasePart
local L=require(game.ReplicatedStorage.RaceAndRaid.HubLayout)
local ep=L.RoutePoint(L.RouteEndX);local c=ep+Vector3.new(140,0,65)
local ray=workspace:Raycast(c+Vector3.new(0,60,0),Vector3.new(0,-120,0))
assert(ray,"no ground")
local bike=(workspace:WaitForChild("Vehicles"):WaitForChild("StreetCub_"..game.Players:GetPlayers()[1].UserId)) :: Model
local seat=bike:WaitForChild("DriveSeat") :: VehicleSeat
local target=CFrame.new(c.X,ray.Position.Y+2.85,c.Z)
bike:PivotTo(target*seat.CFrame:Inverse()*bike:GetPivot())
for _,d in bike:GetDescendants() do if d:IsA("BasePart") then d.AssemblyLinearVelocity=Vector3.zero;d.AssemblyAngularVelocity=Vector3.zero end end
task.wait(1)
root.CFrame=seat.CFrame*CFrame.new(3,2,0)
task.wait(1.5)
seat:Sit(hum)
task.wait(1)
p:SetAttribute("TurnPadCentre",Vector3.new(c.X,ray.Position.Y,c.Z))
return string.format("pad centre %.1f,%.1f,%.1f ground=%s mat=%s occupant=%s",c.X,ray.Position.Y,c.Z,ray.Instance.Name,ray.Material.Name,tostring(seat.Occupant))
