--!strict
local Layout = {
 -- v11 rev2 (owner approved 2026-11-05): Central Hub + Y-fork gateway.
 -- v12 (Master Directive 2026-11-06): Layout B, zones every 250 studs, odd zones left / even right.
 Version=12,
 TerrainVersion=10,
 Pickup=Vector3.new(-250,0,-40),
 -- Deposit/BikeStart/Spawn are derived from the G1 PlotFrame below (single source of truth).
 Deposit=Vector3.zero,
 BikeStart=CFrame.identity,
 SpawnCFrame=CFrame.identity,
 DepositPlot="G1",
 MinX=-1250,MaxX=0,MaxZ=1100, -- MaxX derived from RouteEndX below
 ZoneSpacing=250,ZonePadSize=Vector3.new(100,0,72),ZonePadClearance=4,
 -- Plot-local offsets. Local -Z is the garage front (towards the hub), +Z is the back wall.
 PlotLocal={
  Building=Vector3.new(0,0,23),
  BikeStart=Vector3.new(0,2.85,-10),
  Spawn=Vector3.new(8,3,10),
  DayZoneMin=Vector3.new(-110,0,-70),
  DayZoneMax=Vector3.new(70,0,240),
 },
 Plots={
  -- Left (Z-) G1 bottom -> G3 top; right (Z+) G4 top -> G6 bottom. Doors face the hub.
  {id="G1",position=Vector3.new(-865,0,-225),label="อู่ 1 / Blockout"},
  {id="G2",position=Vector3.new(-745,0,-225),label="อู่ 2 / Blockout"},
  {id="G3",position=Vector3.new(-625,0,-225),label="อู่ 3 / Blockout"},
  {id="G4",position=Vector3.new(-625,0,225),label="อู่ 4 / Blockout"},
  {id="G5",position=Vector3.new(-745,0,225),label="อู่ 5 / Blockout"},
  {id="G6",position=Vector3.new(-865,0,225),label="อู่ 6 / Blockout"},
 },
 LotSize=Vector3.new(100,0,85),
 -- Garage City road network (all at Y=0 on flat Terrain9 ground, X<-320).
 City={
  RoadWidth=32,
  SideZ=150,            -- ring side centreline |Z|
  BottomX=-987,         -- ring bottom centreline X
  CornerRadius=56,      -- bottom corner centreline radius (inner lane 48 = 1.69x measured 28.4)
  ApronDepth=16.5,      -- lot front edge to ring outer edge
  HubHalfZ=134,         -- ring inner edge
  ForkRadius=60,        -- Y-fork arc centreline radius (inner lane 52 = 1.83x)
  ForkTheta=math.rad(50),
  BranchEndZ=24,        -- branch centreline |Z| entering the gateway plaza
  ForkStartX=0,         -- derived below (about -557.7)
  GatewayX1=-396,GatewayX2=-364,GatewayHalfZ=56,
  ThroatX1=-364,ThroatX2=-250, -- existing straight two-way approach; joins MainHighway at X=-250
  EntryX1=-1038,EntryX2=-1003,EntryHalfZ=16,
  SpeedLaneCentre=Vector3.new(-1060,0,0),SpeedLaneWidth=44,SpeedLaneLength=600, -- candidate, B3 drive test pending
  LanePadX1=-1090,LanePadX2=-990,LanePadZ1=300,LanePadZ2=380,
  Landmark=Vector3.new(-760,0,0),LandmarkSize=30,
  CentralPlaza=Vector3.new(-940,0,0),CentralPlazaSize=Vector3.new(30,0,110),
  ExpansionHalfX=55,ExpansionZ1=267.5,ExpansionZ2=400, -- reserved only, not built
 },
 Zones={
  {id=1,name="ซอยช่างบ้านเรา",position=Vector3.new(-250,0,0)},
  {id=2,name="ตลาดน้ำอะไหล่ซิ่ง",position=Vector3.new(0,0,0)},
  {id=3,name="ทุ่งนาซิ่งสายฝุ่น",position=Vector3.new(250,0,0)},
  {id=4,name="ถนนตลาดแซ่บ",position=Vector3.new(500,0,0)},
  {id=5,name="ดอยโค้งร้อยศอก",position=Vector3.new(750,0,0)},
  {id=6,name="สวนยางสายแรง",position=Vector3.new(1000,0,0)},
  {id=7,name="ท่าเรือซิ่งริมเล",position=Vector3.new(1250,0,0)},
  {id=8,name="นิคมเหล็กเดือด",position=Vector3.new(1500,0,0)},
  {id=9,name="บางกอกไนท์เรซ",position=Vector3.new(1750,0,0)},
  {id=10,name="อุโมงค์ช่างเถื่อน",position=Vector3.new(2000,0,0)},
  {id=11,name="นครนีออนไทยแลนด์",position=Vector3.new(2250,0,0)},
  {id=12,name="คลังอะไหล่ตำนาน",position=Vector3.new(2500,0,0)},
 },
 Facilities={
  -- Placeholders only: no backend exists for any facility.
  {name="Race Hub • Placeholder",position=Vector3.new(-520,0,0),size=Vector3.new(80,0,90)},
  {name="Parts Market • Placeholder",position=Vector3.new(-640,0,-85),size=Vector3.new(80,0,60)},
  {name="Shop • Placeholder",position=Vector3.new(-640,0,85),size=Vector3.new(80,0,60)},
  {name="Upgrade Center • Placeholder",position=Vector3.new(-870,0,-85),size=Vector3.new(80,0,60)},
  {name="Event Plaza • Placeholder",position=Vector3.new(-870,0,85),size=Vector3.new(80,0,60)},
 },
}
-- Y-fork start X derived from the gateway and arc parameters (two arcs + 50 degree diagonal).
do
 local c=Layout.City
 local lateral=c.SideZ-c.BranchEndZ
 local arcLat=2*c.ForkRadius*(1-math.cos(c.ForkTheta))
 local diagLat=lateral-arcLat
 c.ForkStartX=c.GatewayX1-(2*c.ForkRadius*math.sin(c.ForkTheta)+diagLat/math.tan(c.ForkTheta))
end
-- Continuous analytic alignment: X always increases; zones never wrap back.
function Layout.RoutePoint(x: number): Vector3
 local t=math.max(0,x+250)
 local z=90*(1-math.cos(t/360))
 local h=math.max(0,x-200)
 local y=16*(1-math.cos(h/380))
 return Vector3.new(x,y,z)
end
-- Garage frame: origin at lot centre, LookVector (local -Z) faces the hub centreline Z=0.
function Layout.PlotFrame(plot: {position: Vector3}): CFrame
 local c=plot.position
 if c.Z>0 then return CFrame.new(c) end
 return CFrame.new(c)*CFrame.Angles(0,math.pi,0)
end
function Layout.FindPlot(id: string)
 for _,plot in Layout.Plots do if plot.id==id then return plot end end
 error("Unknown plot "..id)
end
do
 local frame=Layout.PlotFrame(Layout.FindPlot(Layout.DepositPlot))
 Layout.Deposit=frame.Position
 Layout.BikeStart=frame*CFrame.new(Layout.PlotLocal.BikeStart)
 Layout.SpawnCFrame=frame*CFrame.new(Layout.PlotLocal.Spawn)
end
-- Zones sit on the analytic route. Driving towards +X, left is -Z: odd zones left, even zones right.
-- padNear = gap from the route centreline to the pad's road-side edge, widened where the road bends
-- towards the pad so the pad never overlaps the 44-stud road (22 half-width + clearance).
for i,zone in Layout.Zones do
 zone.position=Layout.RoutePoint(zone.position.X)
 local side=if i%2==1 then -1 else 1
 local half=Layout.ZonePadSize.X/2;local shift=0
 for dx=-half,half,5 do shift=math.max(shift,(Layout.RoutePoint(zone.position.X+dx).Z-zone.position.Z)*side) end
 local near=math.max(34,22+Layout.ZonePadClearance+shift)
 zone.side=side;zone.padNear=near
 zone.padCentre=zone.position+Vector3.new(0,0,side*(near+Layout.ZonePadSize.Z/2))
end
Layout.RouteEndX=Layout.Zones[#Layout.Zones].position.X+60 -- road continues past Zone 12 into the turnaround
Layout.BridgeX=(Layout.Zones[5].position.X+Layout.Zones[6].position.X)/2 -- bridge in the Z05-Z06 gap
Layout.MaxX=Layout.RouteEndX+750
Layout.Pickup=Layout.Zones[1].position+Vector3.new(0,0,Layout.Zones[1].side*(Layout.Zones[1].padNear+21))
return Layout
