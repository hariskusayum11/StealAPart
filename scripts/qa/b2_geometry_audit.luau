-- QA-only (Studio Play Server). B2 geometry audit for Garage City v11. Never shipped.
-- 1) protected highway hash (all parts with min corner X >= -300, plus boundary/fence groups)
-- 2) driving-line surface scan: gaps, height deviation, coplanar duplicate tops (z-fight)
-- 3) collidable obstructions inside the driving corridor  4) fixture smoke checks
local HttpService=game:GetService("HttpService")
local t0=os.clock()
while workspace:GetAttribute("WorldGeometryReady")==nil or not workspace:FindFirstChild("CargoTestCourse") do
 if os.clock()-t0>300 then return "timeout" end;task.wait(1)
end
local course=workspace.CargoTestCourse
local L=require(game.ReplicatedStorage.RaceAndRaid.HubLayout)
local out:{[string]:any}={layoutVersion=course:GetAttribute("LayoutVersion")}
local function r2(v:number):string return string.format("%.2f",math.round(v*100)/100+0) end
local function fnv(str:string):number local h=2166136261;for i=1,#str do h=bit32.bxor(h,string.byte(str,i));h=(h*16777619)%4294967296 end;return h end
local function corners(p:BasePart):({string},number)
 local s=p.Size/2;local list={};local minX=math.huge
 for _,x in {-1,1} do for _,y in {-1,1} do for _,z in {-1,1} do
  local w=p.CFrame:PointToWorldSpace(Vector3.new(x*s.X,y*s.Y,z*s.Z));minX=math.min(minX,w.X)
  table.insert(list,r2(w.X)..","..r2(w.Y)..","..r2(w.Z))
 end end end
 table.sort(list);return list,minX
end
-- 1) protected hash
local vis=course:FindFirstChild("G1Visual")
local groups:{[string]:{string}}={};local total=0
for _,d in course:GetDescendants() do
 if d:IsA("BasePart") and not (vis and d:IsDescendantOf(vis)) then
  total+=1
  local c,minX=corners(d)
  if minX>=-300 or d.Name=="WorldBoundary" or d.Name=="BoundaryFencePost" or d.Name=="BoundaryFenceRail" then
   local key=table.concat({d.ClassName,d.Name,table.concat(c,";"),d.Color:ToHex(),d.Material.Name,r2(d.Transparency),tostring(d.CanCollide)},"|")
   groups[d.Name]=groups[d.Name] or {};table.insert(groups[d.Name],key)
  end
 end
end
local prot={}
for name,list in groups do table.sort(list);prot[name]={n=#list,h=fnv(table.concat(list,"\n"))} end
out.totalCourseParts=total;out.protected=prot
if L.Version<11 then return HttpService:JSONEncode(out) end
-- 2) driving lines (centreline samples with tangents), rebuilt from HubLayout exactly like the generator
local city=L.City;local FS=city.ForkStartX;local R=city.CornerRadius;local cornerX=city.BottomX+R
local paths:{[string]:{{p:Vector3,t:Vector3}}}={}
local function line(name:string,a:Vector3,b:Vector3)
 local list=paths[name] or {};local n=math.max(1,math.ceil((b-a).Magnitude/2));local t=(b-a).Unit
 for i=0,n do table.insert(list,{p=a:Lerp(b,i/n),t=t}) end;paths[name]=list
end
local function arc(name:string,c:Vector3,rad:number,a0:number,a1:number)
 local list=paths[name] or {};local n=math.ceil(math.abs(a1-a0)*rad/2);local dir=if a1>a0 then 1 else -1
 for i=0,n do local a=a0+(a1-a0)*i/n;table.insert(list,{p=c+Vector3.new(math.cos(a),0,math.sin(a))*rad,t=Vector3.new(-math.sin(a),0,math.cos(a))*dir}) end
 paths[name]=list
end
for _,side in {-1,1} do line("ringSide"..side,Vector3.new(cornerX-6,0,side*city.SideZ),Vector3.new(FS+6,0,side*city.SideZ)) end
line("ringBottom",Vector3.new(city.BottomX,0,-(city.SideZ-R)-6),Vector3.new(city.BottomX,0,city.SideZ-R+6))
arc("cornerL",Vector3.new(cornerX,0,-(city.SideZ-R)),R,math.pi,1.5*math.pi)
arc("cornerR",Vector3.new(cornerX,0,city.SideZ-R),R,math.pi,.5*math.pi)
local FR,TH=city.ForkRadius,city.ForkTheta
for _,side in {-1,1} do
 local nm="fork"..side
 local c1=Vector3.new(FS,0,-city.SideZ+FR);arc(nm,c1,FR,-math.pi/2,-math.pi/2+TH)
 local p1=paths[nm][#paths[nm]].p;local dv=Vector3.new(math.cos(TH),0,math.sin(TH))
 local dl=((city.SideZ-city.BranchEndZ)-2*FR*(1-math.cos(TH)))/math.sin(TH)
 line(nm,p1,p1+dv*dl)
 local p2=p1+dv*dl;local c2=p2+Vector3.new(math.sin(TH),0,-math.cos(TH))*FR
 arc(nm,c2,FR,math.pi/2+TH,math.pi/2)
 line(nm,Vector3.new(city.GatewayX1,0,-city.BranchEndZ),Vector3.new(city.GatewayX2,0,-city.BranchEndZ))
 if side==1 then for i,s in paths[nm] do paths[nm][i]={p=Vector3.new(s.p.X,0,-s.p.Z),t=Vector3.new(s.t.X,0,-s.t.Z)} end end
end
line("throat",Vector3.new(city.GatewayX2-4,0,0),Vector3.new(-230,0,0)) -- crosses the X=-250 MainHighway joint
for _,plot in L.Plots do
 local f=L.PlotFrame(plot)
 line("apron"..plot.id,f:PointToWorldSpace(Vector3.new(0,0,-10)),Vector3.new(plot.position.X,0,(if plot.position.Z>0 then 1 else -1)*city.SideZ))
end
line("entry",Vector3.new(city.BottomX,0,0),Vector3.new(city.SpeedLaneCentre.X,0,0))
line("speedLane",city.SpeedLaneCentre-Vector3.new(0,0,city.SpeedLaneLength/2+30),city.SpeedLaneCentre+Vector3.new(0,0,city.SpeedLaneLength/2+30))
-- Surface parts only: paint/markings (CanCollide=false) and G1Visual are excluded from the surface test.
local surfaceParts={}
for _,d in course:GetDescendants() do if d:IsA("BasePart") and d.CanCollide and not (vis and d:IsDescendantOf(vis)) then table.insert(surfaceParts,d) end end
local include=RaycastParams.new();include.FilterType=Enum.RaycastFilterType.Include;include.FilterDescendantsInstances=surfaceParts
local function topHits(q:Vector3):(RaycastResult?,RaycastResult?)
 local first=workspace:Raycast(q+Vector3.new(0,20,0),Vector3.new(0,-40,0),include)
 if not first then return nil,nil end
 local list=table.clone(surfaceParts);local idx=table.find(list,first.Instance);if idx then table.remove(list,idx) end
 local p=RaycastParams.new();p.FilterType=Enum.RaycastFilterType.Include;p.FilterDescendantsInstances=list
 return first,workspace:Raycast(q+Vector3.new(0,20,0),Vector3.new(0,-40,0),p)
end
-- A coplanar pair counts only if it persists at four 0.3-stud jitters (a shared edge does not).
local function realOverlap(q:Vector3,a:Instance,b:Instance):boolean
 for _,j in {Vector3.new(.3,0,.3),Vector3.new(-.3,0,.3),Vector3.new(.3,0,-.3),Vector3.new(-.3,0,-.3)} do
  local f,s=topHits(q+j)
  if not (f and s and math.abs(f.Position.Y-s.Position.Y)<.01) then return false end
  if not ((f.Instance==a and s.Instance==b) or (f.Instance==b and s.Instance==a)) then return false end
 end
 return true
end
local surface={}
local worst={gap=0,dev=0,zfight=0,samples=0}
local issues={}
for name,list in paths do
 local st={samples=0,gaps=0,maxDev=0,zfight=0}
 local offsets=if string.sub(name,1,5)=="apron" then {-8,0,8} else {-14,-8,0,8,14}
 for _,s in list do
  local right=Vector3.new(-s.t.Z,0,s.t.X)
  for _,o in offsets do
   local q=s.p+right*o
   local hit,second=topHits(q)
   st.samples+=1
   if not hit then st.gaps+=1;if #issues<40 then table.insert(issues,{path=name,kind="gap",x=r2(q.X),z=r2(q.Z)}) end
   else
    local dev=math.abs(hit.Position.Y)
    if dev>st.maxDev then st.maxDev=dev end
    if dev>.02 and #issues<40 then table.insert(issues,{path=name,kind="height",y=r2(hit.Position.Y),part=hit.Instance.Name,x=r2(q.X),z=r2(q.Z)}) end
    if second and math.abs(second.Position.Y-hit.Position.Y)<.01 then
     st.sharedEdge=(st.sharedEdge or 0)+1
     if realOverlap(q,hit.Instance,second.Instance) then
      st.zfight+=1;if #issues<40 then table.insert(issues,{path=name,kind="coplanar",a=hit.Instance.Name,b=second.Instance.Name,x=r2(q.X),z=r2(q.Z)}) end
     end
    end
   end
  end
 end
 surface[name]=st
end
out.surface=surface;out.surfaceIssues=issues
-- 3) collidable obstructions in the corridor (0.6..9 studs above road, lane width 30)
local op=OverlapParams.new();op.FilterType=Enum.RaycastFilterType.Include;op.FilterDescendantsInstances={course}
local obstacles={}
for name,list in paths do
 for i=1,#list,3 do
  local s=list[i]
  local cf=CFrame.lookAt(s.p+Vector3.new(0,4.8,0),s.p+Vector3.new(0,4.8,0)+s.t)
  for _,part in workspace:GetPartBoundsInBox(cf,Vector3.new(28,8.4,2),op) do
   if part.CanCollide and part.Transparency<1 then obstacles[name..":"..part.Name]=(obstacles[name..":"..part.Name] or 0)+1 end
  end
 end
end
out.obstacles=obstacles
-- 4) fixture smoke
local dep=workspace:FindFirstChild("TestGarageDeposit") :: BasePart?
local pick=workspace:FindFirstChild("TestScrapPickup") :: BasePart?
local bike=workspace:FindFirstChild("ChassisTestBike") :: Model?
local seat=bike and bike:FindFirstChild("DriveSeat") :: VehicleSeat?
local plr=game.Players:GetPlayers()[1]
local root=plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") :: BasePart?
out.smoke={
 spawn=tostring(workspace.Spawn.Position),layoutSpawn=tostring(L.SpawnCFrame.Position),
 depositOffset=dep and r2((Vector3.new(dep.Position.X,0,dep.Position.Z)-L.Deposit).Magnitude),
 depositPrompt=dep and dep:FindFirstChildOfClass("ProximityPrompt")~=nil,
 pickupExists=pick~=nil,pickupPos=pick and tostring(pick.Position),
 seatToBikeStart=seat and r2((Vector3.new(seat.Position.X,0,seat.Position.Z)-Vector3.new(L.BikeStart.Position.X,0,L.BikeStart.Position.Z)).Magnitude),
 seatLook=seat and tostring(seat.CFrame.LookVector),ridePrompt=seat and seat:FindFirstChild("RidePrompt")~=nil,
 characterToSpawn=root and r2((root.Position-workspace.Spawn.Position).Magnitude),
 g1VisualVersion=vis and vis:GetAttribute("VisualVersion"),g1VisualDescendants=vis and #vis:GetDescendants(),
 g1VisualCentre=vis and tostring(vis:GetPivot().Position),
 plots={},
}
for _,plot in L.Plots do local m=course:FindFirstChild(plot.id);out.smoke.plots[plot.id]=m and m:GetAttribute("PlotId") end
return HttpService:JSONEncode(out)
