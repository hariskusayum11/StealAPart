--!strict
-- R04.4 structural world revision. No imported assets or gameplay changes.
local Layout=require(game.ReplicatedStorage.RaceAndRaid.HubLayout)
local S=require(script.Parent.RoadSurface)
local Course={Pickup=Layout.Pickup,Deposit=Layout.Deposit,BikeStart=Layout.BikeStart}
local asphalt=Color3.fromRGB(62,68,75);local shoulder=Color3.fromRGB(76,80,83)
local gold=Color3.fromRGB(242,194,53);local white=Color3.fromRGB(225,227,223);local cyan=Color3.fromRGB(39,197,229)
function Course.build():Model
 local old=workspace:FindFirstChild("CargoTestCourse")
 if old and old:IsA("Model") then if old:GetAttribute("LayoutVersion")==Layout.Version then require(script.Parent.BoundarySystem).apply(old);require(script.Parent.G1Visual).apply(old);return old end;old:Destroy() end
 require(script.Parent.HighwayTerrain).build()
 local model=Instance.new("Model");model.Name="CargoTestCourse";model:SetAttribute("LayoutVersion",Layout.Version)
 local rects:{S.Rect}={}
 local function rect(name:string,p:Vector3,w:number,d:number,color:Color3,priority:number?)
  table.insert(rects,{x1=p.X-w/2,x2=p.X+w/2,z1=p.Z-d/2,z2=p.Z+d/2,y=p.Y,name=name,color=color,priority=priority or 1})
 end
 local function mark(name:string,size:Vector3,cf:CFrame,color:Color3)
  local p=S.part(model,name,size,cf,color,Enum.Material.SmoothPlastic);p.CanCollide=false;p.CanTouch=false;p.CastShadow=false
 end
 local function sign(p:Vector3,text:string)
  local b=S.part(model,"BlockoutSign",Vector3.new(38,7,.4),CFrame.new(p),Color3.fromRGB(8,21,47),Enum.Material.Metal)
  for _,face in {Enum.NormalId.Front,Enum.NormalId.Back} do
   local g=Instance.new("SurfaceGui");g.Face=face;g.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud;g.PixelsPerStud=20;g.Parent=b
   local l=Instance.new("TextLabel");l.Size=UDim2.fromScale(1,1);l.BackgroundTransparency=1;l.Text=text;l.TextColor3=gold;l.TextScaled=true;l.Font=Enum.Font.GothamBold;l.Parent=g
  end
 end
 local function strip(a:Vector3,b:Vector3,ra:Vector3,rb:Vector3,l:number,r:number,color:Color3,name:string)
  S.quad(model,a+ra*l,a+ra*r,b+rb*l,b+rb*r,color,name)
 end
 -- Straight city highway is partitioned with lots and accesses, not layered over them.
 rect("CityHighway",Vector3.new(-625,0,0),750,44,asphalt)
 local step=20
 for x=-250,3049,step do
  local a=Layout.RoutePoint(x);local b=Layout.RoutePoint(math.min(x+step,3050))
  local ra=CFrame.lookAt(a,Layout.RoutePoint(x+1)).RightVector;ra=Vector3.new(ra.X,0,ra.Z).Unit
  local rb=CFrame.lookAt(b,Layout.RoutePoint(math.min(x+step,3050)+1)).RightVector;rb=Vector3.new(rb.X,0,rb.Z).Unit
  strip(a,b,ra,rb,-22,-16,shoulder,"HighwayShoulder")
  strip(a,b,ra,rb,-16,16,asphalt,"MainHighway")
  strip(a,b,ra,rb,16,22,shoulder,"HighwayShoulder")
  local section=Instance.new("Folder");section.Name="RoadSection";section:SetAttribute("RouteX",x);section:SetAttribute("Width",44);section:SetAttribute("LeftStart",a-ra*22);section:SetAttribute("RightStart",a+ra*22);section.Parent=model
  local cf=CFrame.lookAt((a+b)/2,b)
  for _,side in {-1,1} do mark("EdgeLine",Vector3.new(.22,.025,(b-a).Magnitude),cf*CFrame.new(side*16,.045,0),white) end
  mark("CenterDash",Vector3.new(.25,.025,7),cf*CFrame.new(0,.045,0),gold)
  if x>=990 and x<=1100 then for _,side in {-1,1} do S.part(model,"BridgeRail",Vector3.new(.5,2,(b-a).Magnitude),cf*CFrame.new(side*22.3,1.15,0),cyan,Enum.Material.Metal) end end
  if x%200==150 then task.wait() end
 end
 for x=-990,-250,20 do
  mark("CenterDash",Vector3.new(7,.025,.25),CFrame.new(x,.045,0),gold)
 end
 for _,side in {-1,1} do
  rect("CityShoulder",Vector3.new(-625,0,side*19),750,6,shoulder,2)
  mark("CityEdgeLine",Vector3.new(750,.025,.22),CFrame.new(-625,.045,side*16),white)
 end
 local ep=Layout.RoutePoint(3050)
 rect("EndTurnaround",ep+Vector3.new(140,0,65),280,260,asphalt)
 -- Return uses the opposite lane through the same entry, not a raised diagonal crossover.
 rect("CityTurnaround",Vector3.new(-1000,0,0),90,100,asphalt)
 for _,zone in Layout.Zones do
  local pos=zone.position
  rect("ZonePad",pos+Vector3.new(0,0,-70),100,72,shoulder,2)
  -- Two portals share the exact outer-road vertices, never overlap a flat access slab.
  for _,dx in {-20,0} do
   local p1=Layout.RoutePoint(pos.X+dx);local p2=Layout.RoutePoint(pos.X+dx+20)
   local r1=CFrame.lookAt(p1,Layout.RoutePoint(pos.X+dx+1)).RightVector
   local r2=CFrame.lookAt(p2,Layout.RoutePoint(pos.X+dx+21)).RightVector
   r1=Vector3.new(r1.X,0,r1.Z).Unit;r2=Vector3.new(r2.X,0,r2.Z).Unit
   S.quad(model,p1-r1*22,p2-r2*22,Vector3.new(pos.X+dx,pos.Y,pos.Z-34),Vector3.new(pos.X+dx+20,pos.Y,pos.Z-34),asphalt,"ZoneAccessRamp")
  end
  local tag=Instance.new("Model");tag.Name=string.format("Zone%02d",zone.id);tag:SetAttribute("ZoneId",zone.id);tag.Parent=model
  sign(pos+Vector3.new(0,12,-116),string.format("%02d %s",zone.id,zone.name))
 end
 for _,plot in Layout.Plots do
  local c=plot.position;local back=if c.Z>0 then 1 else -1
  -- Front access ends at lot edge and at the highway shoulder; flat partition removes overlap.
  rect("GarageAccess",Vector3.new(c.X,0,back*40),32,80,asphalt)
  rect("GarageLot",c,100,85,Color3.fromRGB(110,115,123),3)
  rect("GarageJunction",Vector3.new(c.X,0,0),64,64,asphalt)
  local tag=Instance.new("Model");tag.Name=plot.id;tag:SetAttribute("PlotId",plot.id);tag.Parent=model
  local b=c+Vector3.new(0,0,back*23)
  for _,side in {-1,1} do S.part(tag,"GarageShell",Vector3.new(2,20,32),CFrame.new(b+Vector3.new(side*35,10,0)),Color3.fromRGB(61,72,91),Enum.Material.Concrete) end
  S.part(tag,"GarageBack",Vector3.new(72,20,2),CFrame.new(b+Vector3.new(0,10,back*16)),asphalt,Enum.Material.Concrete)
  S.part(tag,"GarageRoof",Vector3.new(76,2,36),CFrame.new(b+Vector3.new(0,21,0)),Color3.fromRGB(36,44,62),Enum.Material.Metal)
  sign(b+Vector3.new(0,25,-back*18),plot.id.." • อู่ต้นแบบ")
  mark("ParkingMark",Vector3.new(8,.025,12),CFrame.new(c+Vector3.new(0,.045,-back*19)),cyan)
 end
 for _,z in {-220,220} do rect("CityServiceRoad",Vector3.new(-700,0,z),680,32,asphalt) end
 for _,x in {-1040,-360} do rect("CityCrossRoad",Vector3.new(x,0,0),32,440,asphalt) end
 -- Rear access enters behind the lot without crossing any other plot.
 for _,plot in Layout.Plots do
  local back=if plot.position.Z>0 then 1 else -1
  rect("GarageSideAccess",Vector3.new(plot.position.X+51,0,back*155),16,130,asphalt)
  rect("GarageSideApron",plot.position+Vector3.new(43,0,0),32,32,asphalt)
 end
 for _,f in Layout.Facilities do
  local z=if f.position.Z>0 then 220 else -220
  rect("FacilityAccess",Vector3.new(f.position.X,0,(z+f.position.Z)/2),32,math.abs(z-f.position.Z),asphalt)
  rect("FacilityReservation",f.position,100,90,Color3.fromRGB(105,104,118),2)
  sign(f.position+Vector3.new(0,12,if f.position.Z>0 then 48 else -48),f.name)
 end
 rect("SpeedTestLane",Vector3.new(-760,0,-430),600,44,asphalt)
 rect("TrackAccess",Vector3.new(-900,0,-365),32,130,asphalt)
 S.flat(model,rects)
 for _,x in {1014,1050,1086} do
  local p=Layout.RoutePoint(x)
  for _,z in {-17,17} do S.part(model,"BridgePier",Vector3.new(3,p.Y+30,3),CFrame.new(p.X,(p.Y-30)/2,p.Z+z),Color3.fromRGB(132,139,146),Enum.Material.Concrete) end
 end
 require(script.Parent.BoundarySystem).apply(model)
 -- Limited boundary studies: timber fence, canal bank and field bunds. Not final imported art.
 for _,sample in {{x=-760,z=980},{x=-250,z=-980}} do
  for i=-3,3 do
   local ground=workspace:Raycast(Vector3.new(sample.x+i*18,100,sample.z),Vector3.new(0,-180,0))
   local p=Vector3.new(sample.x+i*18,(if ground then ground.Position.Y else 0)+3,sample.z)
   S.part(model,"BoundaryFencePost",Vector3.new(.6,6,.6),CFrame.new(p),Color3.fromRGB(95,75,52),Enum.Material.Wood)
   if i<3 then for _,y in {-1,1} do S.part(model,"BoundaryFenceRail",Vector3.new(18,.4,.5),CFrame.new(p+Vector3.new(9,y,0)),Color3.fromRGB(123,99,67),Enum.Material.Wood) end end
  end
 end
 require(script.Parent.G1Visual).apply(model)
 model.Parent=workspace;workspace:SetAttribute("WorldGeometryReady",Layout.Version)
 return model
end
return Course