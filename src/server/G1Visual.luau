--!strict
-- Owner-approved G1-only architecture study. Original collision shell and road remain authoritative.
-- v5: identical geometry to v4, now expressed in G1 plot-local space via Layout.PlotFrame.
local Layout=require(game.ReplicatedStorage.RaceAndRaid.HubLayout)
local Visual={Version=5}
local cream=Color3.fromRGB(232,224,201)
local navy=Color3.fromRGB(27,46,64)
local teal=Color3.fromRGB(26,124,131)
local coral=Color3.fromRGB(219,82,58)
local gold=Color3.fromRGB(245,181,53)
local steel=Color3.fromRGB(71,86,94)
function Visual.apply(course:Model)
 local prior=course:FindFirstChild("G1Visual")
 if prior then if prior:GetAttribute("VisualVersion")==Visual.Version then return end;prior:Destroy() end
 local original=course:FindFirstChild("G1")
 if not original then return end
 local root=Instance.new("Model");root.Name="G1Visual";root:SetAttribute("VisualVersion",Visual.Version)
 local frame=Layout.PlotFrame(Layout.FindPlot("G1"))
 local origin=frame*CFrame.new(Layout.PlotLocal.Building)
 local function part(name:string,size:Vector3,pos:Vector3,color:Color3,material:Enum.Material?,rotation:CFrame?):Part
  local p=Instance.new("Part");p.Name=name;p.Size=size;p.CFrame=origin*CFrame.new(pos)*(rotation or CFrame.identity).Rotation;p.Color=color;p.Material=material or Enum.Material.Metal
  p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth;p.Parent=root;return p
 end
 local function beam(name:string,a:Vector3,b:Vector3,width:number,color:Color3)
  return part(name,Vector3.new(width,width,(b-a).Magnitude),(a+b)/2,color,Enum.Material.Metal,CFrame.lookAt(a,b))
 end
 local function textPanel(name:string,pos:Vector3,size:Vector3,text:string,color:Color3,textColor:Color3)
  local p=part(name,size,pos,color)
  local gui=Instance.new("SurfaceGui");gui.Face=Enum.NormalId.Front;gui.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud;gui.PixelsPerStud=30;gui.LightInfluence=.3;gui.Parent=p
  local label=Instance.new("TextLabel");label.Size=UDim2.fromScale(1,1);label.BackgroundTransparency=1;label.Text=text;label.TextColor3=textColor;label.Font=Enum.Font.GothamBold;label.TextScaled=true;label.Parent=gui
 end
 -- Retain every original collidable shell at identical dimensions and transforms.
 for _,p in original:GetChildren() do
  if p:IsA("BasePart") then
   if p.Name=="GarageRoof" then p.Transparency=1
   elseif p.Name=="GarageShell" then p.Color=cream
   elseif p.Name=="GarageBack" then p.Color=teal end
  end
 end
 -- Remove only G1's old prototype sign and cyan visual tile, never fixtures or attachments.
 for _,p in course:GetChildren() do
  local l=if p:IsA("BasePart") then frame:PointToObjectSpace(p.Position) else nil
  if l and math.abs(l.X)<1 then
   -- Plot-local: sign at Building+(0,25,-18) => z 5; ParkingMark at z -19.
   if p.Name=="BlockoutSign" and math.abs(l.Z-5)<1 then p.Transparency=1;for _,g in p:GetChildren() do if g:IsA("SurfaceGui") then g.Enabled=false end end end
   if p.Name=="ParkingMark" and math.abs(l.Z+19)<1 then p.Transparency=1 end
  end
 end
 -- Double pitched metal roof with exposed trusses and folded fascia.
 local rise=7;local half=39;local slope=math.atan(rise/half)
 for _,side in {-1,1} do
  part("StandingSeamRoof",Vector3.new(math.sqrt(half*half+rise*rise),.6,40),Vector3.new(side*half/2,23.5,0),navy,Enum.Material.Metal,CFrame.Angles(0,0,-side*slope))
  for z=-19,19,3.8 do beam("RoofSeam",Vector3.new(0,27.1,z),Vector3.new(side*39,20.1,z),.12,steel) end
  beam("Eave",Vector3.new(side*39,20,-21),Vector3.new(side*39,20,21),.6,coral)
  for z=-15,15,30 do
   part("Column",Vector3.new(1,20,1),Vector3.new(side*33,10,z),navy)
   beam("KneeBrace",Vector3.new(side*33,16,z),Vector3.new(side*28,20,z),.6,steel)
  end
  beam("FrontRoofFascia",Vector3.new(0,27,-20.5),Vector3.new(side*39,20,-20.5),.8,coral)
 end
 beam("RidgeCap",Vector3.new(0,27.2,-21),Vector3.new(0,27.2,21),.7,steel)
 for z=-14,14,14 do
  beam("TieBeam",Vector3.new(-33,19.8,z),Vector3.new(33,19.8,z),.6,steel)
  beam("TrussLeft",Vector3.new(-33,20,z),Vector3.new(0,26,z),.45,steel)
  beam("TrussRight",Vector3.new(0,26,z),Vector3.new(33,20,z),.45,steel)
 end
 part("SignFrame",Vector3.new(61,7.2,.8),Vector3.new(0,19.4,-19.8),coral)
 textPanel("GarageIdentity",Vector3.new(0,19.4,-20.25),Vector3.new(59,5.6,.12),"อู่ช่างบ้านเรา  /  G1",navy,Color3.fromRGB(255,232,163))
 textPanel("WorkshopSubtitle",Vector3.new(0,14.7,14.85),Vector3.new(42,2.7,.12),"STREET CUB • SERVICE & PARTS",navy,cream)
 -- Painted epoxy floor and bay graphics: visual only, not an extra collidable floor.
 part("EpoxyPaint",Vector3.new(66,.018,29),Vector3.new(0,.065,0),Color3.fromRGB(143,155,154),Enum.Material.Concrete)
 for _,x in {-16,16} do
  for _,side in {-1,1} do part("BayLine",Vector3.new(.2,.015,22),Vector3.new(x+side*9,.09,-1),cream,Enum.Material.SmoothPlastic) end
  part("BayStopLine",Vector3.new(18,.015,.2),Vector3.new(x,.09,10),gold,Enum.Material.SmoothPlastic)
 end
 for _,side in {-1,1} do
  part("WallSkirt",Vector3.new(.25,3,30),Vector3.new(side*33.85,1.6,0),navy)
  for z=-12,12,4 do part("WallBatten",Vector3.new(.25,13,.25),Vector3.new(side*33.8,10,z),steel) end
 end
 -- Noninteractive workbench, drawers, pegboard and two parts racks at rear; leave centre aisle clear.
 part("WorkbenchTop",Vector3.new(17,.6,4),Vector3.new(-21,4,12),Color3.fromRGB(143,105,61),Enum.Material.Wood)
 for _,x in {-27,-15} do part("BenchLeg",Vector3.new(.7,4,3),Vector3.new(x,2,12),steel) end
 part("ToolChest",Vector3.new(8,3.7,3),Vector3.new(-21,1.9,12),coral)
 for y=1,3,1 do part("DrawerPull",Vector3.new(6,.15,.15),Vector3.new(-21,y,10.4),cream) end
 part("Pegboard",Vector3.new(16,5,.3),Vector3.new(-21,9,14.6),navy)
 for x=-27,-15,3 do
  part("ToolHandle",Vector3.new(.18,2,.15),Vector3.new(x,9,14.3),gold)
  part("ToolHead",Vector3.new(.9,.4,.2),Vector3.new(x,10.1,14.3),steel)
 end
 for _,x in {19,29} do
  for _,dx in {-3.6,3.6} do part("RackUpright",Vector3.new(.4,10,.4),Vector3.new(x+dx,5,13),navy) end
  for y=1,9,4 do
   part("PartsShelf",Vector3.new(8,.3,3.5),Vector3.new(x,y,13),steel)
   local box=part("PartsCrate",Vector3.new(3,2,2.5),Vector3.new(x,y+1.2,13),if y==5 then teal else gold)
   part("CrateLabel",Vector3.new(2,.45,.03),Vector3.new(x,y+1.3,11.73),cream)
  end
 end
 -- Two warm lights only, no animated effects or per-frame decoration scripts.
 for _,x in {-20,20} do
  local p=part("WorkshopLuminaire",Vector3.new(8,.2,1),Vector3.new(x,19,-4),Color3.fromRGB(255,227,169),Enum.Material.Neon)
  local light=Instance.new("PointLight");light.Range=22;light.Brightness=.65;light.Shadows=false;light.Color=Color3.fromRGB(255,225,177);light.Parent=p
 end
 -- Cargo location is unchanged: a painted outline replaces the developer tile visually.
 for _,side in {-1,1} do
  part("CargoOutline",Vector3.new(.15,.018,6),Vector3.new(side*3,.09,-23),gold,Enum.Material.SmoothPlastic)
  part("CargoOutline",Vector3.new(6,.018,.15),Vector3.new(0,.09,-23+side*3),gold,Enum.Material.SmoothPlastic)
 end
 -- Forecourt parking paint and safe side planters, not curbs in the driving lane.
 for _,x in {-26,26} do part("ApronBayEdge",Vector3.new(.2,.02,25),Vector3.new(x,.07,-29),cream,Enum.Material.SmoothPlastic) end
 textPanel("DepositSign",Vector3.new(-29,5,-26),Vector3.new(10,4,.4),"ฝากอะไหล่\nF • CARGO",teal,cream)
 local function planter(x:number,z:number)
  part("Planter",Vector3.new(4,2.2,6),Vector3.new(x,1.1,z),coral,Enum.Material.Concrete)
  part("PlanterSoil",Vector3.new(3.6,.15,5.6),Vector3.new(x,2.22,z),Color3.fromRGB(84,66,44),Enum.Material.Ground)
  for i=1,6 do
   local a=i*math.pi/3
   local leaf=Instance.new("WedgePart");leaf.Name="TropicalLanceLeaf";leaf.Size=Vector3.new(.14,1.8,5)
   leaf.CFrame=origin*CFrame.new(x+math.sin(a)*1.2,3.5,z+math.cos(a)*1.2)*CFrame.Angles(-.5,a,.25)
   leaf.Color=if i%2==0 then Color3.fromRGB(62,131,71) else Color3.fromRGB(104,161,71);leaf.Material=Enum.Material.Grass
   leaf.Anchored=true;leaf.CanCollide=false;leaf.CanTouch=false;leaf.CanQuery=false;leaf.CastShadow=false;leaf.Parent=root
  end
 end
 planter(-43,-25);planter(-43,0)
 -- Mid-ground slatted screen behind G1 only, set beyond service road and kept off side access.
 for _,x in {-37,0,37} do
  part("ScreenPost",Vector3.new(.6,12,.6),Vector3.new(x,6,166),navy)
 end
 for y=2,11,1.5 do part("BackgroundSlat",Vector3.new(76,.55,.35),Vector3.new(0,y,166),Color3.fromRGB(135,115,75),Enum.Material.Wood) end
 for i=1,7 do
  local x=-43+i*11
  local p=part("StreetPennant",Vector3.new(2.5,3,.1),Vector3.new(x,12.5,165.5),if i%2==0 then coral else teal,Enum.Material.Fabric)
  p.CastShadow=false
 end
 -- Reuse original grass and distant earth silhouettes; no fake imported trees/buildings.
 root.Parent=course
 root:SetAttribute("Source","Project-authored native architecture; no external asset import")
end
return Visual