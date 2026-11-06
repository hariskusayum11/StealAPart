-- QA-only (Studio Play Server). M3 Layout B audit: zone pads vs road/bridge/each other, pad and
-- connector surfaces (gaps / terrain on top), highway surface + terrain protrusion + collidable obstacles.
local HttpService=game:GetService("HttpService")
local t0=os.clock()
while workspace:GetAttribute("WorldGeometryReady")==nil or not workspace:FindFirstChild("CargoTestCourse") do
 if os.clock()-t0>300 then return "timeout" end;task.wait(1)
end
local course=workspace.CargoTestCourse
local L=require(game.ReplicatedStorage.RaceAndRaid.HubLayout)
local function r2(v) return math.floor(v*100+.5)/100 end
local out={layoutVersion=course:GetAttribute("LayoutVersion"),terrainVersion=workspace.Terrain:GetAttribute("HighwayFoundationVersion"),routeEndX=L.RouteEndX,bridgeX=L.BridgeX,maxX=L.MaxX,zones={},issues={}}
local rp=RaycastParams.new();rp.FilterType=Enum.RaycastFilterType.Include;rp.FilterDescendantsInstances={course,workspace.Terrain}
local function top(x,z) return workspace:Raycast(Vector3.new(x,200,z),Vector3.new(0,-400,0),rp) end
local cp=RaycastParams.new();cp.FilterType=Enum.RaycastFilterType.Include;cp.FilterDescendantsInstances={course}
local function issue(t) if #out.issues<60 then table.insert(out.issues,t) end end
local half=L.ZonePadSize/2
-- 1) pads: rectangle relations
for i,z in L.Zones do
 local c=z.padCentre
 local rec={id=z.id,side=if z.side<0 then "L" else "R",x=r2(c.X),padZ=r2(c.Z),roadZ=r2(z.position.Z),y=r2(z.position.Y),near=r2(z.padNear),minRoadClear=math.huge}
 for dx=-half.X,half.X,2 do
  local x=c.X+dx;local road=L.RoutePoint(x)
  local nearEdgeZ=c.Z-z.side*half.Z
  rec.minRoadClear=math.min(rec.minRoadClear,r2(math.abs(nearEdgeZ-road.Z)-22))
 end
 rec.bridgeGap=r2(math.abs(c.X-L.BridgeX)-half.X-50)
 for j,o in L.Zones do if j~=i and math.abs(o.padCentre.X-c.X)<half.X*2 and math.abs(o.padCentre.Z-c.Z)<half.Z*2 then issue({kind="padOverlap",a=z.id,b=o.id}) end end
 -- pad surface: grid of top hits must be the ZonePad part at pad height (no gap, no terrain above)
 local samples,bad=0,0
 for gx=-45,45,9 do for gz=-33,33,11 do
  samples+=1;local h=top(c.X+gx,c.Z+gz)
  if not h then bad+=1;issue({kind="padGap",zone=z.id,x=r2(c.X+gx),z=r2(c.Z+gz)})
  elseif h.Instance==workspace.Terrain or math.abs(h.Position.Y-z.position.Y)>.05 then bad+=1;issue({kind="padTop",zone=z.id,hit=h.Instance.Name,y=r2(h.Position.Y),x=r2(c.X+gx),z=r2(c.Z+gz)}) end
 end end
 rec.padSamples=samples;rec.padBad=bad
 -- connector: from road edge to pad near edge across the 80-stud ramp, the top hit must be asphalt (not terrain/gap)
 local cs,cb=0,0
 for dx=-38,38,4 do
  local x=z.position.X+dx;local road=L.RoutePoint(x)
  for f=0.1,0.9,0.2 do
   local zz=road.Z+z.side*(22+(z.padNear-22)*f);cs+=1
   local h=top(x,zz)
   if not h or h.Instance==workspace.Terrain then
    cb+=1
    local surf=workspace:Raycast(Vector3.new(x,200,zz),Vector3.new(0,-400,0),cp)
    local above=if h and surf then r2(h.Position.Y-surf.Position.Y) else nil
    rec.maxTerrainAbove=math.max(rec.maxTerrainAbove or 0,above or 99)
    issue({kind="connector",zone=z.id,hit=h and h.Instance.Name or "none",x=r2(x),z=r2(zz),terrainAbove=above})
   end
  end
 end
 rec.connectorSamples=cs;rec.connectorBad=cb
 table.insert(out.zones,rec)
end
-- 2) highway: lanes -14..14 every 4 studs from X -250 to RouteEndX
local hs,gaps,terrainOnTop,maxStep=0,0,0,0
local prevY={}
for x=-250,L.RouteEndX-2,4 do
 local p=L.RoutePoint(x);local q=L.RoutePoint(x+1);local t=Vector3.new(q.X-p.X,0,q.Z-p.Z).Unit;local right=Vector3.new(-t.Z,0,t.X)
 for _,o in {-14,-8,0,8,14} do
  local s=p+right*o;hs+=1;local h=top(s.X,s.Z)
  if not h then gaps+=1;issue({kind="roadGap",x=r2(s.X),z=r2(s.Z)})
  elseif h.Instance==workspace.Terrain and h.Position.Y>p.Y-.05 then terrainOnTop+=1;issue({kind="terrainOnRoad",x=r2(s.X),z=r2(s.Z),y=r2(h.Position.Y),road=r2(p.Y)})
  else if prevY[o] then maxStep=math.max(maxStep,math.abs(h.Position.Y-prevY[o])) end;prevY[o]=h.Position.Y end
 end
end
out.highway={samples=hs,gaps=gaps,terrainOnTop=terrainOnTop,maxStepPer4=r2(maxStep)}
-- 3) collidable obstacles in the highway corridor (0.6..9 above road, 28 wide)
local op=OverlapParams.new();op.FilterType=Enum.RaycastFilterType.Include;op.FilterDescendantsInstances={course}
local obstacles={}
for x=-250,L.RouteEndX-2,6 do
 local p=L.RoutePoint(x);local q=L.RoutePoint(x+1)
 local cf=CFrame.lookAt(p+Vector3.new(0,4.8,0),q+Vector3.new(0,4.8,0))
 for _,part in workspace:GetPartBoundsInBox(cf,Vector3.new(28,8.4,2),op) do
  if part.CanCollide and part.Transparency<1 then obstacles[part.Name]=(obstacles[part.Name] or 0)+1 end
 end
end
out.obstacles=obstacles
local n=0;for _,d in course:GetDescendants() do if d:IsA("BasePart") then n+=1 end end;out.courseParts=n
out.pickup=tostring(L.Pickup)
return HttpService:JSONEncode(out)
