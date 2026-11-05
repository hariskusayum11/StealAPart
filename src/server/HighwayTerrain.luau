--!strict
local Layout=require(game.ReplicatedStorage.RaceAndRaid.HubLayout)
local Terrain={}
function Terrain.build()
 local t=workspace.Terrain
 local foundationVersion=Layout.TerrainVersion or Layout.Version
 if t:GetAttribute("HighwayFoundationVersion")==foundationVersion then return end
 local function height(x:number,z:number):number
  local p=Layout.RoutePoint(math.clamp(x,-1000,3050));local away=math.abs(z-p.Z)
  local top=p.Y-.12+math.clamp((away-120)/300,0,1)*(8+6*math.noise(x/380,z/420))
  if x< -320 and math.abs(z)<550 then top=-.12 end
  for _,zone in Layout.Zones do
   local dx=math.abs(x-zone.position.X);local dz=math.abs(z-(zone.position.Z-70))
   if dx<70 and dz<56 and away>28 then
    local weight=math.min(math.clamp((70-dx)/20,0,1),math.clamp((56-dz)/20,0,1),math.clamp((away-28)/6,0,1))
    top=top*(1-weight)+(zone.position.Y-.12)*weight
   end
  end
  if x>=3030 and x<=3350 and z>p.Z-85 and z<p.Z+215 then top=Layout.RoutePoint(3050).Y-.12 end
  local edge=math.min(x-Layout.MinX,Layout.MaxX-x,Layout.MaxZ-math.abs(z))
  local berm=math.clamp((100-edge)/100,0,1)
  return top+berm*berm*(32+5*math.noise(x/190,z/190))
 end
 -- Only this generator's existing footprint; remove the old distant spherical ridge masses.
 for x=-1408,4096,256 do t:FillBlock(CFrame.new(x,130,0),Vector3.new(256,420,2560),Enum.Material.Air);task.wait() end
 for x=Layout.MinX-32,Layout.MaxX+32,64 do
  for z=-Layout.MaxZ-32,Layout.MaxZ+32,64 do
   local top=height(x,z)
   t:FillBlock(CFrame.new(x,(top-80)/2,z),Vector3.new(64,top+80,64),Enum.Material.Grass)
  end
  task.wait()
 end
 -- Fine occupancy in the play corridor removes the old 64-stud terrain stair steps.
 local function fine(x1:number,x2:number,z1:number,z2:number,y1:number,y2:number)
  local region=Region3.new(Vector3.new(x1,y1,z1),Vector3.new(x2,y2,z2)):ExpandToGrid(4)
  local size=region.Size/4;local origin=region.CFrame.Position-region.Size/2
  local mats={};local occupancy={}
  for ix=1,size.X do
   mats[ix]={};occupancy[ix]={}
   for iy=1,size.Y do mats[ix][iy]={};occupancy[ix][iy]={} end
   for iz=1,size.Z do
    local top=height(origin.X+(ix-.5)*4,origin.Z+(iz-.5)*4)
    for iy=1,size.Y do
     local bottom=origin.Y+(iy-1)*4
     mats[ix][iy][iz]=Enum.Material.Grass;occupancy[ix][iy][iz]=math.clamp((top-2-bottom)/4,0,1)
    end
   end
  end
  t:WriteVoxels(region,4,mats,occupancy)
 end
 for x=-1120,-321,64 do fine(x,math.min(x+64,-320),-528,528,-12,16);task.wait() end
 for x=-320,3359,64 do
  local p=Layout.RoutePoint(math.clamp(x+32,-1000,3050));local z=math.floor(p.Z/4)*4
  local bottom=math.floor(p.Y/4)*4-12
  fine(x,x+64,z-120,z+120,bottom,bottom+36);task.wait()
 end
 local p=Layout.RoutePoint(3050)
 for x=3040,3319,64 do fine(x,x+64,math.floor((p.Z-84)/4)*4,math.ceil((p.Z+216)/4)*4,0,36);task.wait() end
 -- Boundary studies only, far outside every drive/loot corridor: native canal and field banks.
 -- Zone02 canal study is landscape, not an imported market or completed zone.
 local canalY=height(50,-850)
 t:FillBlock(CFrame.new(50,canalY-3,-850),Vector3.new(220,12,28),Enum.Material.Air)
 t:FillBlock(CFrame.new(50,canalY-6,-850),Vector3.new(220,6,28),Enum.Material.Water)
 -- Zone03 field bunds follow actual ground; no decorative buildings or tree substitutes.
 for i=0,3 do
  local z=820+i*18;local y=height(350,z)
  t:FillBlock(CFrame.new(350,y-.4,z),Vector3.new(210,1.5,3),Enum.Material.Ground)
 end
 -- Supported bridge remains the only exception to a ground-level shoulder.
 t:FillBlock(CFrame.new(1050,5,140),Vector3.new(80,70,880),Enum.Material.Air)
 t:FillBlock(CFrame.new(1050,-16,140),Vector3.new(80,10,880),Enum.Material.Water)
 t:SetAttribute("HighwayFoundationVersion",foundationVersion)
end
return Terrain