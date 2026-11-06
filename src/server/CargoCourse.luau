--!strict
-- R04.4 structural world revision. No imported assets or gameplay changes.
local Layout=require(game.ReplicatedStorage.RaceAndRaid.HubLayout)
local S=require(script.Parent.RoadSurface)
local Course={Pickup=Layout.Pickup,Deposit=Layout.Deposit,BikeStart=Layout.BikeStart}
local asphalt=Color3.fromRGB(62,68,75);local shoulder=Color3.fromRGB(76,80,83)
local gold=Color3.fromRGB(242,194,53);local white=Color3.fromRGB(225,227,223);local cyan=Color3.fromRGB(39,197,229)
type Sample={p:Vector3,t:Vector3}
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
 local function sign(p:Vector3,text:string,yaw:number?)
  local b=S.part(model,"BlockoutSign",Vector3.new(38,7,.4),CFrame.new(p)*CFrame.Angles(0,yaw or 0,0),Color3.fromRGB(8,21,47),Enum.Material.Metal)
  for _,face in {Enum.NormalId.Front,Enum.NormalId.Back} do
   local g=Instance.new("SurfaceGui");g.Face=face;g.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud;g.PixelsPerStud=20;g.Parent=b
   local l=Instance.new("TextLabel");l.Size=UDim2.fromScale(1,1);l.BackgroundTransparency=1;l.Text=text;l.TextColor3=gold;l.TextScaled=true;l.Font=Enum.Font.GothamBold;l.Parent=g
  end
 end
 local function strip(a:Vector3,b:Vector3,ra:Vector3,rb:Vector3,l:number,r:number,color:Color3,name:string)
  S.quad(model,a+ra*l,a+ra*r,b+rb*l,b+rb*r,color,name)
 end
 local city=Layout.City
 local throatLen=city.ThroatX2-city.ThroatX1;local throatMid=(city.ThroatX1+city.ThroatX2)/2
 -- v11: only the short straight throat remains between the Y-fork gateway and MainHighway (X=-250).
 rect("CityHighway",Vector3.new(throatMid,0,0),throatLen,44,asphalt)
 local step=20
 local endX=Layout.RouteEndX;local bridgeX=Layout.BridgeX
 for x=-250,endX-1,step do
  local a=Layout.RoutePoint(x);local b=Layout.RoutePoint(math.min(x+step,endX))
  local ra=CFrame.lookAt(a,Layout.RoutePoint(x+1)).RightVector;ra=Vector3.new(ra.X,0,ra.Z).Unit
  local rb=CFrame.lookAt(b,Layout.RoutePoint(math.min(x+step,endX)+1)).RightVector;rb=Vector3.new(rb.X,0,rb.Z).Unit
  strip(a,b,ra,rb,-22,-16,shoulder,"HighwayShoulder")
  strip(a,b,ra,rb,-16,16,asphalt,"MainHighway")
  strip(a,b,ra,rb,16,22,shoulder,"HighwayShoulder")
  local section=Instance.new("Folder");section.Name="RoadSection";section:SetAttribute("RouteX",x);section:SetAttribute("Width",44);section:SetAttribute("LeftStart",a-ra*22);section:SetAttribute("RightStart",a+ra*22);section.Parent=model
  local cf=CFrame.lookAt((a+b)/2,b)
  for _,side in {-1,1} do mark("EdgeLine",Vector3.new(.22,.025,(b-a).Magnitude),cf*CFrame.new(side*16,.045,0),white) end
  mark("CenterDash",Vector3.new(.25,.025,7),cf*CFrame.new(0,.045,0),gold)
  if x>=bridgeX-50 and x<bridgeX+50 then for _,side in {-1,1} do S.part(model,"BridgeRail",Vector3.new(.5,2,(b-a).Magnitude),cf*CFrame.new(side*22.3,1.15,0),cyan,Enum.Material.Metal) end end
  if x%200==150 then task.wait() end
 end
 -- Same dash phase as v10 (-990+20k), limited to the throat.
 for x=-990,-250,20 do
  if x-3.5>=city.ThroatX1 then mark("CenterDash",Vector3.new(7,.025,.25),CFrame.new(x,.045,0),gold) end
 end
 for _,side in {-1,1} do
  rect("CityShoulder",Vector3.new(throatMid,0,side*19),throatLen,6,shoulder,2)
  mark("CityEdgeLine",Vector3.new(throatLen,.025,.22),CFrame.new(throatMid,.045,side*16),white)
 end
 local ep=Layout.RoutePoint(endX)
 rect("EndTurnaround",ep+Vector3.new(140,0,65),280,260,asphalt)
 for _,zone in Layout.Zones do
  local pos=zone.position
  local side,near=zone.side,zone.padNear
  rect("ZonePad",zone.padCentre,Layout.ZonePadSize.X,Layout.ZonePadSize.Z,shoulder,2)
  -- Four portals share the exact outer-road vertices, never overlap a flat access slab.
  -- >=80-stud connector (room to U-turn on the pad without reverse). Portals start on a road vertex
  -- (sections every 20 studs from X=-250) so they share the exact outer-road vertices: 4 portals when the
  -- zone is vertex-aligned, 5 (= full 100-stud pad width) when it is not.
  local xa=-250+20*math.floor((pos.X-40+250)/20)
  while xa<pos.X+40 do
   local xb=xa+20
   local p1=Layout.RoutePoint(xa);local p2=Layout.RoutePoint(xb)
   local r1=CFrame.lookAt(p1,Layout.RoutePoint(xa+1)).RightVector
   local r2=CFrame.lookAt(p2,Layout.RoutePoint(xb+1)).RightVector
   r1=Vector3.new(r1.X,0,r1.Z).Unit;r2=Vector3.new(r2.X,0,r2.Z).Unit
   S.quad(model,p1+r1*22*side,p2+r2*22*side,Vector3.new(xa,pos.Y,pos.Z+side*near),Vector3.new(xb,pos.Y,pos.Z+side*near),asphalt,"ZoneAccessRamp")
   xa=xb
  end
  local tag=Instance.new("Model");tag.Name=string.format("Zone%02d",zone.id);tag:SetAttribute("ZoneId",zone.id);tag.Parent=model
  sign(zone.padCentre+Vector3.new(0,12,side*(Layout.ZonePadSize.Z/2+10)),string.format("%02d %s",zone.id,zone.name))
 end
 for _,plot in Layout.Plots do
  local c=plot.position;local frame=Layout.PlotFrame(plot)
  -- Lot plus full-width apron to the ring outer edge (pull-through frontage, no reverse needed).
  rect("GarageLot",c,Layout.LotSize.X,Layout.LotSize.Z,Color3.fromRGB(110,115,123),3)
  rect("GarageApron",frame:PointToWorldSpace(Vector3.new(0,0,-(Layout.LotSize.Z+city.ApronDepth)/2)),Layout.LotSize.X,city.ApronDepth,asphalt)
  local tag=Instance.new("Model");tag.Name=plot.id;tag:SetAttribute("PlotId",plot.id);tag.Parent=model
  -- Garage shell is built in plot-local space (local -Z = front towards hub, +Z = back wall).
  local b=Layout.PlotLocal.Building
  local function at(offset:Vector3):CFrame return frame*CFrame.new(offset) end
  for _,side in {-1,1} do S.part(tag,"GarageShell",Vector3.new(2,20,32),at(b+Vector3.new(side*35,10,0)),Color3.fromRGB(61,72,91),Enum.Material.Concrete) end
  S.part(tag,"GarageBack",Vector3.new(72,20,2),at(b+Vector3.new(0,10,16)),asphalt,Enum.Material.Concrete)
  S.part(tag,"GarageRoof",Vector3.new(76,2,36),at(b+Vector3.new(0,21,0)),Color3.fromRGB(36,44,62),Enum.Material.Metal)
  sign(at(b+Vector3.new(0,25,-18)).Position,plot.id.." • อู่ต้นแบบ")
  mark("ParkingMark",Vector3.new(8,.025,12),at(Vector3.new(0,.045,-19)),cyan)
 end
 -- ===== v11 service ring (two-way, 32 wide): straight sides/bottom are flat rects ending exactly
 -- at arc tangent points; curves are WedgePart ribbons (same quad technique as MainHighway).
 local W=city.RoadWidth;local half=W/2;local R=city.CornerRadius;local FS=city.ForkStartX
 local cornerX=city.BottomX+R
 local function dashes(name:string,a:Vector3,b:Vector3)
  local len=(b-a).Magnitude;local n=math.floor(len/20)
  for i=0,n-1 do local p=a:Lerp(b,(i+.5)/n);mark(name,Vector3.new(.25,.025,7),CFrame.lookAt(p,b)*CFrame.new(0,.045,0),gold) end
 end
 for _,side in {-1,1} do
  rect("RingSide",Vector3.new((cornerX+FS)/2,0,side*city.SideZ),FS-cornerX,W,asphalt)
  dashes("RingDash",Vector3.new(cornerX,0,side*city.SideZ),Vector3.new(FS,0,side*city.SideZ))
 end
 rect("RingBottom",Vector3.new(city.BottomX,0,0),W,2*(city.SideZ-R),asphalt)
 dashes("RingDash",Vector3.new(city.BottomX,0,-(city.SideZ-R)),Vector3.new(city.BottomX,0,city.SideZ-R))
 -- Ribbon from sampled centreline points with exact unit tangents; right vector = (-t.Z,0,t.X).
 local function ribbon(samples:{Sample},name:string)
  for i=1,#samples-1 do
   local s1,s2=samples[i],samples[i+1]
   local r1=Vector3.new(-s1.t.Z,0,s1.t.X);local r2=Vector3.new(-s2.t.Z,0,s2.t.X)
   strip(s1.p,s2.p,r1,r2,-half,half,asphalt,name)
   if i%2==1 then local m=(s1.p+s2.p)/2;mark("RingDash",Vector3.new(.25,.025,math.min(7,(s2.p-s1.p).Magnitude*.8)),CFrame.lookAt(m,s2.p)*CFrame.new(0,.045,0),gold) end
  end
 end
 local function arc(centre:Vector3,radius:number,a0:number,a1:number,segments:number,out:{Sample}?):{Sample}
  local list=out or {};local dir=if a1>a0 then 1 else -1
  for i=0,segments do
   local a=a0+(a1-a0)*i/segments
   local s={p=centre+Vector3.new(math.cos(a),0,math.sin(a))*radius,t=Vector3.new(-math.sin(a),0,math.cos(a))*dir}
   if not (out and i==0 and #list>0) then table.insert(list,s) end
  end
  return list
 end
 -- Bottom corners: quarter arcs from the bottom side (angle pi) to each ring side.
 ribbon(arc(Vector3.new(cornerX,0,-(city.SideZ-R)),R,math.pi,1.5*math.pi,12),"RingCorner")
 ribbon(arc(Vector3.new(cornerX,0,city.SideZ-R),R,math.pi,.5*math.pi,12),"RingCorner")
 -- Y-fork branches: arc (turn in) -> 50 degree diagonal -> arc (turn back to +X) into the gateway plaza.
 local FR,TH=city.ForkRadius,city.ForkTheta
 for _,side in {-1,1} do
  local samples:{Sample}={}
  -- Built for the left branch (Z<0) then mirrored by side; mirroring Z keeps tangents consistent.
  local c1=Vector3.new(FS,0,-city.SideZ+FR)
  arc(c1,FR,-math.pi/2,-math.pi/2+TH,10,samples)
  local p1=samples[#samples].p;local dirv=Vector3.new(math.cos(TH),0,math.sin(TH))
  local diagLen=((city.SideZ-city.BranchEndZ)-2*FR*(1-math.cos(TH)))/math.sin(TH)
  for i=1,4 do table.insert(samples,{p=p1+dirv*diagLen*i/4,t=dirv}) end
  local p2=samples[#samples].p
  local c2=p2+Vector3.new(math.sin(TH),0,-math.cos(TH))*FR
  arc(c2,FR,math.pi/2+TH,math.pi/2,10,samples)
  if side==1 then for i,s in samples do samples[i]={p=Vector3.new(s.p.X,0,-s.p.Z),t=Vector3.new(s.t.X,0,-s.t.Z)} end end
  ribbon(samples,"ForkBranch")
 end
 rect("GatewayPlaza",Vector3.new((city.GatewayX1+city.GatewayX2)/2,0,0),city.GatewayX2-city.GatewayX1,2*city.GatewayHalfZ,asphalt)
 -- Central hub floor (walkable, no road through it). Corner boxes are excluded so flat rects never
 -- overlap the curved ribbons; the small verge inside each corner stays grass.
 local hubColour=Color3.fromRGB(150,146,136)
 rect("HubFloor",Vector3.new((cornerX+FS)/2,0,0),FS-cornerX,2*city.HubHalfZ,hubColour)
 local innerX=city.BottomX+half
 rect("HubFloor",Vector3.new((innerX+cornerX)/2,0,0),cornerX-innerX,2*(city.SideZ-R),hubColour)
 for _,f in Layout.Facilities do
  rect("FacilityReservation",f.position,f.size.X,f.size.Z,Color3.fromRGB(105,104,118),2)
  sign(f.position+Vector3.new(0,14,0),f.name)
 end
 rect("LandmarkReservation",city.Landmark,city.LandmarkSize,city.LandmarkSize,Color3.fromRGB(196,160,60),2)
 sign(city.Landmark+Vector3.new(0,14,0),"◆ STEAL A PART! Landmark • Placeholder")
 rect("CentralPlaza",city.CentralPlaza,city.CentralPlazaSize.X,city.CentralPlazaSize.Z,Color3.fromRGB(176,170,158),2)
 -- Pedestrian crossings opposite each garage door (paint only, non-collidable).
 for _,plot in Layout.Plots do
  local zc=(if plot.position.Z>0 then 1 else -1)*city.SideZ
  for k=-4,4 do mark("Crosswalk",Vector3.new(6,.025,1.6),CFrame.new(plot.position.X,.045,zc+k*3.4),white) end
 end
 -- Direction signs facing drivers heading +X towards the gateway.
 -- Signs stay on the hub floor (|Z|<=128), never overhanging a driving lane.
 for _,side in {-1,1} do sign(Vector3.new(FS-12,12,side*(city.HubHalfZ-25)),"↑ HIGHWAY • ZONE 01–12",math.pi/2) end
 -- City entry road and candidate SpeedTestLane (position not locked until B3 drive test).
 rect("CityEntry",Vector3.new((city.EntryX1+city.EntryX2)/2,0,0),city.EntryX2-city.EntryX1,2*city.EntryHalfZ,asphalt)
 sign(Vector3.new((city.EntryX1+city.EntryX2)/2,12,city.EntryHalfZ+24),"CITY ENTRY • GARAGE CITY",math.pi/2)
 rect("SpeedTestLane",city.SpeedLaneCentre,city.SpeedLaneWidth,city.SpeedLaneLength,asphalt)
 for _,side in {-1,1} do
  rect("SpeedLaneTurnPad",Vector3.new((city.LanePadX1+city.LanePadX2)/2,0,side*(city.LanePadZ1+city.LanePadZ2)/2),city.LanePadX2-city.LanePadX1,city.LanePadZ2-city.LanePadZ1,asphalt)
 end
 dashes("RingDash",city.SpeedLaneCentre-Vector3.new(0,0,city.SpeedLaneLength/2),city.SpeedLaneCentre+Vector3.new(0,0,city.SpeedLaneLength/2))
 sign(city.SpeedLaneCentre+Vector3.new(-city.SpeedLaneWidth/2-18,12,0),"SPEED TEST LANE • Candidate",math.pi/2)
 S.flat(model,rects)
 for _,x in {bridgeX-36,bridgeX,bridgeX+36} do
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