-- QA-only; respects collision and measures geometry rather than labels.
local l=require(game.ReplicatedStorage.RaceAndRaid.HubLayout)
local m=workspace.CargoTestCourse
local rp=RaycastParams.new();rp.FilterType=Enum.RaycastFilterType.Include;rp.FilterDescendantsInstances={m};rp.RespectCanCollide=true
local tr=RaycastParams.new();tr.FilterType=Enum.RaycastFilterType.Include;tr.FilterDescendantsInstances={workspace.Terrain};tr.RespectCanCollide=true
local minimum=math.huge;local maximum=0;local sections=0;local parts=0;local duplicates=0;local keys={};local boundaries=0
for _,v in m:GetDescendants() do
 if v:IsA("BasePart") then
  parts+=1;if v.Name=="WorldBoundary" then boundaries+=1 end
  if v.CanCollide then local key=v.ClassName..tostring(v.CFrame)..tostring(v.Size) if keys[key] then duplicates+=1 else keys[key]=true end end
 end
 if v.Name=="RoadSection" then
  local a=v:GetAttribute("LeftStart");local b=v:GetAttribute("RightStart")
  if typeof(a)=="Vector3" and typeof(b)=="Vector3" then local width=(b-a).Magnitude;minimum=math.min(minimum,width);maximum=math.max(maximum,width);sections+=1 end
 end
end
local roadMiss=0;local samples=0;local edgeDifference=0;local roadError=0;local terrainAbove=0
for x=-240,3030,20 do
 local p=l.RoutePoint(x);local right=CFrame.lookAt(p,l.RoutePoint(x+1)).RightVector;right=Vector3.new(right.X,0,right.Z).Unit
 for _,offset in {-21.9,-15,0,15,21.9} do
  local q=p+right*offset;local hit=workspace:Raycast(q+Vector3.new(0,12,0),Vector3.new(0,-24,0),rp);samples+=1
  if not hit then roadMiss+=1 else roadError=math.max(roadError,math.abs(hit.Position.Y-p.Y)) end
 end
 if x<980 or x>1120 then
  for _,side in {-1,1} do
   local q=p+right*(side*24);local hit=workspace:Raycast(q+Vector3.new(0,12,0),Vector3.new(0,-24,0),tr)
   if hit then local diff=hit.Position.Y-p.Y;edgeDifference=math.max(edgeDifference,math.abs(diff));if diff>.4 then terrainAbove+=1 end end
  end
 end
end
local garage={}
for _,g in l.Plots do
 local row={id=g.id,missing=0,maxDelta=0}
 for _,dz in {-40,-20,0,20,35} do
  local q=g.position+Vector3.new(0,0,dz);local hit=workspace:Raycast(q+Vector3.new(0,1,0),Vector3.new(0,-4,0),rp)
  if not hit then row.missing+=1 else row.maxDelta=math.max(row.maxDelta,math.abs(hit.Position.Y)) end
 end
 table.insert(garage,row)
end
return {version=l.Version,sections=sections,minWidth=minimum,maxWidth=maximum,collidableDuplicateBoxes=duplicates,parts=parts,boundaryPlanes=boundaries,roadSamples=samples,roadMiss=roadMiss,maxRoadHeightError=roadError,maxGrassEdgeHeightDifference=edgeDifference,terrainAboveRoad=terrainAbove,garages=garage}