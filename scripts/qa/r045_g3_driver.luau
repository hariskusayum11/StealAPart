-- QA-only virtual driver, injected into Client during Studio Play. Never shipped.
local player=game.Players.LocalPlayer
local bike=workspace.ChassisTestBike
local seat=bike.DriveSeat
local ui=player.PlayerGui:WaitForChild("A-Chassis Interface",10)
assert(ui,"Mount bike before QA")
local virtual=ui.Drive.VirtualInput
local control=ui:WaitForChild("Controls")
local layout=require(game.ReplicatedStorage.RaceAndRaid.HubLayout)
local points={Vector3.new(-520,0,85),Vector3.new(-520,0,60),Vector3.new(-520,0,40)}
for i=1,8 do local a=i*math.pi/16 table.insert(points,Vector3.new(-480-40*math.cos(a),0,40-40*math.sin(a))) end
table.insert(points,Vector3.new(-460,0,0))
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
local started=os.clock();local index=player:GetAttribute("G3QAResume") or 1;local lastProgress=os.clock();local maxX=seat.Position.X
local visited={};local samples={};local nextSample=0
player:SetAttribute("G3QAResult",nil)
player:SetAttribute("G3QAState","running")
task.spawn(function()
 local reason="timeout"
 local ok,err=pcall(function()
  send("ContlrShiftUp",Vector3.zero,Enum.UserInputState.Begin)
  send("ContlrShiftUp",Vector3.zero,Enum.UserInputState.End)
  while os.clock()-started<480 do
   if not seat.Occupant then reason="dismounted";break end
   local p=seat.Position;local speed=seat.AssemblyLinearVelocity.Magnitude
   if seat.CFrame.UpVector.Y<.35 then reason="fallen";break end
   while index<=#points do
    local d=points[index]-p
    if Vector3.new(d.X,0,d.Z).Magnitude<8 then index+=1;lastProgress=os.clock() else break end
   end
   if index>#points then reason="complete";break end
   if os.clock()-lastProgress>18 then reason="stalled";break end
   local target=points[index]
   local localGoal=seat.CFrame:PointToObjectSpace(Vector3.new(target.X,p.Y,target.Z))
   local angle=math.atan2(localGoal.X,-localGoal.Z)
   local s=math.clamp(angle*1.4,-.85,.85)
   steer(s)
   local desired=if index<12 or index>#points-8 then 7 elseif index>190 and index<220 then 12 elseif math.abs(angle)>.4 then 9 elseif math.abs(angle)>.15 then 15 else 28
   throttle(if speed<desired then .65 else 0)
   brake(if speed>desired+4 then .25 else 0)
   maxX=math.max(maxX,p.X)
   for _,zone in layout.Zones do
    local d=zone.position-p
    if Vector3.new(d.X,0,d.Z).Magnitude<35 then visited[tostring(zone.id)]=true end
   end
   if os.clock()>nextSample then
    nextSample=os.clock()+3
    table.insert(samples,{t=math.floor(os.clock()-started),x=p.X,y=p.Y,z=p.Z,speed=speed,index=index})
    player:SetAttribute("G3QAProgress",game:GetService("HttpService"):JSONEncode({index=index,total=#points,maxX=maxX,elapsed=os.clock()-started,position={p.X,p.Y,p.Z},speed=speed}))
   end
   task.wait(.08)
  end
 end)
 throttle(0);steer(0);brake(0)
 if not ok then reason=tostring(err) end
 player:SetAttribute("G3QAState",reason)
 player:SetAttribute("G3QAResult",game:GetService("HttpService"):JSONEncode({reason=reason,elapsed=os.clock()-started,index=index,total=#points,maxX=maxX,visited=visited,samples=samples}))
end)
return "Physical chassis QA running; no teleport, direct velocity or CFrame modification"
