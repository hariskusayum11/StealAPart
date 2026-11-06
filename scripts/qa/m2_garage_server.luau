-- QA-only (Studio Play Server). M2 garage ownership with the real player + mock owners via ServerStorage.QAHook.
local P=game.Players:GetPlayers()[1]
local hook=game.ServerStorage:WaitForChild("QAHook")
local L=require(game.ReplicatedStorage.RaceAndRaid.HubLayout)
local H=game:GetService("HttpService")
local function r2(x) return math.floor(x*100+.5)/100 end
local out={players=#game.Players:GetPlayers()}
out.soloPlot=P:GetAttribute("PlotId")
local bike=workspace.Vehicles:FindFirstChild("StreetCub_"..P.UserId)
out.soloBike=bike and bike.Name;out.bikeOwner=bike and bike:GetAttribute("OwnerUserId");out.bikeCount0=#workspace.Vehicles:GetChildren()
local frame=L.PlotFrame(L.FindPlot(out.soloPlot))
out.charToSpawn=r2((P.Character.HumanoidRootPart.Position-(frame*CFrame.new(L.PlotLocal.Spawn)).Position).Magnitude)
out.mock={}
for i=1,5 do local id=-100-i;local plot=hook:Invoke("assign",id,"Mock"..i);out.mock["m"..i]=plot or "nil";if plot then hook:Invoke("spawnBike",id,"Mock"..i,plot) end end
out.seventh=hook:Invoke("assign",-199,"Mock7") or "nil"
out.snapshot=hook:Invoke("snapshot")
out.reassignSame=hook:Invoke("assign",-101,"Mock1")
hook:Invoke("release",-103);hook:Invoke("despawn",-103)
out.afterRelease=hook:Invoke("snapshot")
out.newcomer=hook:Invoke("assign",-106,"Mock6") or "nil"
if out.newcomer~="nil" then hook:Invoke("spawnBike",-106,"Mock6",out.newcomer) end
out.markers={};for _,m in workspace.PlotOwnership:GetChildren() do out.markers[m.Name]=m:GetAttribute("OwnerUserId") or "free" end
task.wait(8)
out.bikes={}
for _,b in workspace.Vehicles:GetChildren() do
 local pid=b:GetAttribute("PlotId");local f=L.PlotFrame(L.FindPlot(pid))
 out.bikes[b.Name]={plot=pid,owner=b:GetAttribute("OwnerUserId"),distToStart=r2((b.DriveSeat.Position-(f*CFrame.new(L.PlotLocal.BikeStart)).Position).Magnitude),seatEnabled=not b.DriveSeat.Disabled,upY=r2(b.DriveSeat.CFrame.UpVector.Y)}
end
-- touch-sit on a foreign bike must eject
local foreign=workspace.Vehicles:FindFirstChild("StreetCub_-101")
local hum=P.Character.Humanoid
local m0=P:GetAttribute("CargoMessageId")
foreign.DriveSeat:Sit(hum);task.wait(.6)
out.foreignSit={occupantAfter=foreign.DriveSeat.Occupant~=nil,humSeat=hum.SeatPart and hum.SeatPart:GetFullName() or "none",msg=P:GetAttribute("CargoMessage"),msgChanged=P:GetAttribute("CargoMessageId")~=m0}
return H:JSONEncode(out)
