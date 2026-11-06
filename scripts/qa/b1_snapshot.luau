-- QA-only (Studio Play Server). Orientation-independent geometry snapshot of CargoTestCourse.
-- Each BasePart -> class|name|sorted 8 world corners (0.01)|colour|material|transparency|collide.
-- Returns per-name {count, fnv} plus key fixture transforms. Never shipped.
local t0=os.clock()
while not workspace:FindFirstChild("CargoTestCourse") or workspace:GetAttribute("WorldGeometryReady")==nil do
 if os.clock()-t0>240 then return "timeout waiting for geometry" end
 task.wait(1)
end
local course=workspace.CargoTestCourse
local vis=course:FindFirstChild("G1Visual")
local w0=os.clock();while not vis and os.clock()-w0<30 do task.wait(.5);vis=course:FindFirstChild("G1Visual") end
local function r(v:number):string return string.format("%.2f",math.round(v*100)/100+0) end
local function corners(p:BasePart):string
 local s=p.Size/2;local list={}
 for _,x in {-1,1} do for _,y in {-1,1} do for _,z in {-1,1} do
  local w=p.CFrame:PointToWorldSpace(Vector3.new(x*s.X,y*s.Y,z*s.Z))
  table.insert(list,r(w.X)..","..r(w.Y)..","..r(w.Z))
 end end end
 table.sort(list);return table.concat(list,";")
end
local function fnv(str:string):number
 local h=2166136261
 for i=1,#str do h=bit32.bxor(h,string.byte(str,i));h=(h*16777619)%4294967296 end
 return h
end
local groups:{[string]:{string}}={}
local total=0
for _,d in course:GetDescendants() do
 if d:IsA("BasePart") then
  local group=(if d:IsDescendantOf(vis or course) and vis then "G1Visual/" else "")..d.Name
  local key=table.concat({d.ClassName,d.Name,corners(d),d.Color:ToHex(),d.Material.Name,r(d.Transparency),tostring(d.CanCollide)},"|")
  groups[group]=groups[group] or {};table.insert(groups[group],key);total+=1
 end
end
local out={total=total,groups={}}
for name,list in groups do table.sort(list);out.groups[name]={n=#list,h=fnv(table.concat(list,"\n"))} end
local L=require(game.ReplicatedStorage.RaceAndRaid.HubLayout)
local bike=(workspace:FindFirstChild("Vehicles") and workspace.Vehicles:FindFirstChild("StreetCub_"..game.Players:GetPlayers()[1].UserId))
local seat=bike and bike:FindFirstChild("DriveSeat")
local dep=workspace:FindFirstChild("TestGarageDeposit")
out.fixtures={spawn=tostring(workspace.Spawn.CFrame.Position),deposit=dep and tostring(dep.Position),layoutDeposit=tostring(L.Deposit),
 bikeStart=tostring(L.BikeStart),seat=seat and tostring(seat.Position),g1VisualVersion=vis and vis:GetAttribute("VisualVersion"),
 g1VisualParts=vis and #vis:GetDescendants(),layoutVersion=course:GetAttribute("LayoutVersion")}
return game:GetService("HttpService"):JSONEncode(out)
