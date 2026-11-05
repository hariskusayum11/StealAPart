-- QA-only virtual driver, injected into Client during Studio Play. Never shipped.
local player=game.Players.LocalPlayer
local bike=workspace.ChassisTestBike
local seat=bike.DriveSeat
local ui=player.PlayerGui:WaitForChild("A-Chassis Interface",10)
assert(ui,"Mount bike before QA")
local virtual=ui.Drive.VirtualInput
local control=ui:WaitForChild("Controls")
local layout=require(game.ReplicatedStorage.RaceAndRaid.HubLayout)
local points={Vector3.new(-760,0,60),Vector3.new(-760,0,40)}
for i=1,8 do local a=i*math.pi/16 table.insert(points,Vector3.new(-720-40*math.cos(a),0,40-40*math.sin(a))) end
for x=-720,-660,20 do table.insert(points,layout.RoutePoint(x)) end
for x=-640,-520,10 do table.insert(points,Vector3.new(x,0,38*math.sin(math.pi*(x+640)/120)^2)) end
for x=-500,-260,20 do table.insert(points,layout.RoutePoint(x)) end
for _,p in {Vector3.new(-250,0,-5),Vector3.new(-250,0,-25),Vector3.new(-250,0,-55)} do table.insert(points,p) end
local pickupIndex=#points
for i=1,16 do local a=-i*math.pi/16 table.insert(points,Vector3.new(-270+20*math.cos(a),0,-55+20*math.sin(a))) end
for _,p in {Vector3.new(-290,0,-30),Vector3.new(-280,0,-5),Vector3.new(-250,0,0)} do table.insert(points,p) end
local highwayIndex=#points
for x=-230,3050,20 do table.insert(points,layout.RoutePoint(x)) end
local endp=layout.RoutePoint(3050)
table.insert(points,endp);table.insert(points,endp+Vector3.new(45,0,0))
for i=1,16 do local a=-math.pi/2+i*math.pi/16 table.insert(points,Vector3.new(3095+45*math.cos(a),endp.Y,endp.Z+45+45*math.sin(a))) end
table.insert(points,endp+Vector3.new(20,0,50))
for x=3010,-720,-20 do table.insert(points,layout.RoutePoint(x)) end
for _,p in {Vector3.new(-742,0,0),Vector3.new(-760,0,20),Vector3.new(-760,0,60),Vector3.new(-760,0,84)} do table.insert(points,p) end
local depositIndex=#points
local function send(key,pos,state)
 virtual:Fire({KeyCode=Enum.KeyCode[control[key].Value],UserInputType=Enum.UserInputType.Gamepad1,UserInputState=state or Enum.UserInputState.Change,Position=pos},false)
end
local function steer(v)
 local dz=0.15
 local input=if math.abs(v)<.001 then 0 else math.sign(v)*(dz+(1-dz)*math.abs(v))
 send("ContlrSteer",Vector3.new(input,0,0))
end
local function throttle(v) send("ContlrThrottle",Vector3.new(0,0,v)) end
local function brake(v) send("ContlrBrake",Vector3.new(0,0,v)) end
local started=os.clock();local index=player:GetAttribute("CombinedQAResume") or 1;local lastProgress=os.clock();local maxX=seat.Position.X
local closest=math.huge;local visited={};local samples={};local nextSample=0
player:SetAttribute("CombinedQAResult",nil)
player:SetAttribute("CombinedQAState","running")
task.spawn(function()
 local reason="timeout"
 local ok,err=pcall(function()
  send("ContlrShiftUp",Vector3.zero,Enum.UserInputState.Begin)
  send("ContlrShiftUp",Vector3.zero,Enum.UserInputState.End)
  while os.clock()-started<720 do
   if not seat.Occupant then reason="dismounted";break end
   local p=seat.Position;local speed=seat.AssemblyLinearVelocity.Magnitude
   if seat.CFrame.UpVector.Y<.35 then reason="fallen";break end
   while index<=#points do
    local d=points[index]-p
    if Vector3.new(d.X,0,d.Z).Magnitude<(if index<highwayIndex then 10 else 8) then
     if index==pickupIndex or index==depositIndex then
      local pickup=index==pickupIndex;player:SetAttribute("CombinedQAState",if pickup then "await-pickup" else "await-deposit")
      local t=os.clock()
      while os.clock()-t<120 do
       throttle(0);steer(0);brake(if seat.AssemblyLinearVelocity.Magnitude>.5 then .4 else 0)
       if (pickup and (player:GetAttribute("TestCargo") or 0)>0) or (not pickup and (player:GetAttribute("TestSecured") or 0)>0) then break end
       task.wait(.1)
      end
      if os.clock()-t>=120 then error("F input timeout") end
      player:SetAttribute("CombinedQAState","running")
     end
     index+=1;lastProgress=os.clock();closest=math.huge
    else break end
   end
   if index>#points then reason="complete";break end
   if os.clock()-lastProgress>18 then reason="stalled";break end
   local target=points[index]
   local distance=Vector3.new(target.X-p.X,0,target.Z-p.Z).Magnitude
   if distance<closest-1 then closest=distance;lastProgress=os.clock() end
   local localGoal=seat.CFrame:PointToObjectSpace(Vector3.new(target.X,p.Y,target.Z))
   local angle=math.atan2(localGoal.X,-localGoal.Z)
   local s=math.clamp(angle*1.4,-.85,.85)
   steer(s)
   local desired=if index<highwayIndex or index>#points-8 then (if math.abs(angle)>.35 then 4.5 else 8) elseif p.X>2900 then 12 elseif math.abs(angle)>.4 then 9 else 28
   throttle(if speed<desired then .65 else 0)
   brake(if speed>desired+4 then .25 else 0)
   maxX=math.max(maxX,p.X)
   for _,zone in layout.Zones do
    local d=zone.position-p
    if Vector3.new(d.X,0,d.Z).Magnitude<35 then visited[tostring(zone.id)]=true end
   end
   if os.clock()>nextSample then
    nextSample=os.clock()+3
    local rp=RaycastParams.new();rp.FilterType=Enum.RaycastFilterType.Include;rp.FilterDescendantsInstances={workspace.Terrain,workspace.CargoTestCourse};rp.RespectCanCollide=true
    local hit=workspace:Raycast(p+Vector3.new(0,1,0),Vector3.new(0,-10,0),rp)
    local ground=hit and hit.Instance.Name or "missing"
    if p.X>-650 and p.X< -510 and ground=="Terrain" then player:SetAttribute("GrassQAObserved",true) end
    table.insert(samples,{t=math.floor(os.clock()-started),x=p.X,y=p.Y,z=p.Z,speed=speed,index=index,ground=ground})
    player:SetAttribute("CombinedQAProgress",game:GetService("HttpService"):JSONEncode({index=index,total=#points,maxX=maxX,elapsed=os.clock()-started,position={p.X,p.Y,p.Z},speed=speed}))
   end
   task.wait(.08)
  end
 end)
 throttle(0);steer(0);brake(0)
 if not ok then reason=tostring(err) end
 player:SetAttribute("CombinedQAState",reason)
 player:SetAttribute("CombinedQAResult",game:GetService("HttpService"):JSONEncode({reason=reason,elapsed=os.clock()-started,index=index,total=#points,maxX=maxX,visited=visited,samples=samples}))
end)
return "Physical chassis QA running; no teleport, direct velocity or CFrame modification"