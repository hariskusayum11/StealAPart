-- QA-only (Studio Play Client). Pedestrian access test: walk (Humanoid:MoveTo) from the G1 spawn through the
-- crosswalk into the Central Hub and on to every facility, logging which surfaces are walked on. Never shipped.
local L=require(game.ReplicatedStorage.RaceAndRaid.HubLayout)
local city=L.City
local player=game.Players.LocalPlayer
local ch=player.Character
local hum=ch:FindFirstChildOfClass("Humanoid")
local root=ch:FindFirstChild("HumanoidRootPart")
local road={RingSide=true,RingBottom=true,RingCorner=true,ForkBranch=true,GatewayPlaza=true,CityHighway=true,CityShoulder=true,CityEntry=true,GarageApron=true}
local g1=L.FindPlot("G1");local f=L.PlotFrame(g1)
local legs={
 {name="spawn->G1 door",p=f:PointToWorldSpace(Vector3.new(0,0,-40))},
 {name="G1 door->crosswalk->hub edge",p=Vector3.new(g1.position.X,0,-city.HubHalfZ+6)},
}
for _,fac in L.Facilities do table.insert(legs,{name="->"..fac.name,p=fac.position}) end
table.insert(legs,{name="->Landmark",p=city.Landmark})
table.insert(legs,{name="->Central Plaza",p=city.CentralPlaza})
local rp=RaycastParams.new();rp.FilterType=Enum.RaycastFilterType.Exclude;rp.FilterDescendantsInstances={ch,workspace.ChassisTestBike}
player:SetAttribute("B3Walk",nil)
task.spawn(function()
 local out={}
 for _,leg in legs do
  local t0=os.clock();local surfaces={};local roadSamples=0;local reached=false
  while os.clock()-t0<45 do
   hum:MoveTo(Vector3.new(leg.p.X,root.Position.Y,leg.p.Z))
   for _=1,10 do
    task.wait(.2)
    local g=workspace:Raycast(root.Position,Vector3.new(0,-8,0),rp)
    local n=if g then (if g.Instance==workspace.Terrain then "Terrain" else g.Instance.Name) else "none"
    surfaces[n]=(surfaces[n] or 0)+1;if road[n] then roadSamples+=1 end
    if (Vector3.new(root.Position.X,0,root.Position.Z)-Vector3.new(leg.p.X,0,leg.p.Z)).Magnitude<4 then reached=true;break end
   end
   if reached then break end
  end
  table.insert(out,{leg=leg.name,reached=reached,seconds=math.floor((os.clock()-t0)*10)/10,roadSamples=roadSamples,surfaces=surfaces})
 end
 player:SetAttribute("B3Walk",game:GetService("HttpService"):JSONEncode(out))
end)
return "walk test started"
