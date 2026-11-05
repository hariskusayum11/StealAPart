-- QA-only continuous garage/shoulder/Cargo route, no pivot or teleport.
local player=game.Players.LocalPlayer
local seat=workspace.ChassisTestBike.DriveSeat
local layout=require(game.ReplicatedStorage.RaceAndRaid.HubLayout)
task.spawn(function()
 while player:GetAttribute("RouteQAState")=="running" do task.wait(.3) end
 if player:GetAttribute("RouteQAState")~="complete" then player:SetAttribute("GarageQAState","previous-roundtrip-failed");return end
 local ui=player.PlayerGui:WaitForChild("A-Chassis Interface",10);if not ui then return end
 local virtual=ui.Drive.VirtualInput;local controls=ui.Controls
 local points={};local tags={}
 local function add(x,z,tag) table.insert(points,Vector3.new(x,0,z));if tag then tags[#points]=tag end end
 for _,gi in {1,2,3,6,5,4} do
  local g=layout.Plots[gi];local cx=g.position.X;local back=if g.position.Z>0 then 1 else -1
  local entry=cx-back*12
  if gi~=1 then add(entry,back*35);add(entry,back*70) end
  add(entry,back*94);add(entry,back*108)
  for j=1,8 do local a=if back==1 then math.pi-j*math.pi/8 else -j*math.pi/8;add(cx+12*math.cos(a),back*108+12*math.sin(a)) end
  add(cx+back*12,back*80);add(cx+back*12,back*45,"garage-"..gi)
  if gi==3 then add(cx+12,0);add(cx+12,-40) end
 end
 add(-800,-35);add(-840,0);add(-1040,0);add(-1040,220);add(-709,220);add(-709,155);add(-709,90);add(-709,50,"service-road");add(-680,25);add(-640,0)
 for x=-620,-420,10 do local t=(x+620)/200;add(x,40*math.sin(math.pi*t)^2,if x==-520 then "grass" else nil) end
 add(-300,0);add(-250,-10);add(-250,-35);add(-250,-55,"pickup")
 add(-250,-75);add(-280,-75);add(-295,-45);add(-295,-10);add(-320,0)
 for x=-340,-720,-20 do add(x,0) end
 add(-748,5);add(-760,25);add(-760,60);add(-760,84,"deposit")
 local function send(key,pos,state) virtual:Fire({KeyCode=Enum.KeyCode[controls[key].Value],UserInputType=Enum.UserInputType.Gamepad1,UserInputState=state or Enum.UserInputState.Change,Position=pos},false) end
 local function input(throttle,brake,steer)
  send("ContlrThrottle",Vector3.new(0,0,throttle));send("ContlrBrake",Vector3.new(0,0,brake))
  local s=if math.abs(steer)<.001 then 0 else math.sign(steer)*(.15+.85*math.abs(steer))
  send("ContlrSteer",Vector3.new(s,0,0))
 end
 local started=os.clock();local progress=os.clock();local index=1;local closest=math.huge;local visited={};local reason="timeout";local samples={};local nextSample=0
 player:SetAttribute("GarageQAState","running")
 while os.clock()-started<1200 do
  if not seat.Occupant then reason="dismounted";break end
  local p=seat.Position;local speed=seat.AssemblyLinearVelocity.Magnitude
  if seat.CFrame.UpVector.Y<.35 then reason="fallen";break end
  if index>#points then reason="complete";break end
  local target=points[index];local distance=Vector3.new(target.X-p.X,0,target.Z-p.Z).Magnitude
  if distance<closest-1 then closest=distance;progress=os.clock() end
  if distance<3.2 then
   local tag=tags[index]
   if tag=="pickup" or tag=="deposit" then
    player:SetAttribute("GarageQAState","await-"..tag)
    local waitStart=os.clock()
    while os.clock()-waitStart<90 do
     input(0,if seat.AssemblyLinearVelocity.Magnitude>.5 then .4 else 0,0)
     if (tag=="pickup" and (player:GetAttribute("TestCargo") or 0)>0) or (tag=="deposit" and (player:GetAttribute("TestSecured") or 0)>0) then break end
     task.wait(.1)
    end
    if os.clock()-waitStart>=90 then reason=tag.."-input-timeout";break end
    player:SetAttribute("GarageQAState","running")
   end
   if tag then visited[tag]=true end
   index+=1;progress=os.clock();closest=math.huge
  else
   if os.clock()-progress>30 then reason="stalled";break end
   local goal=seat.CFrame:PointToObjectSpace(Vector3.new(target.X,p.Y,target.Z));local angle=math.atan2(goal.X,-goal.Z)
   local desired=if math.abs(angle)>.4 then 4 elseif index<80 then 5.5 else 8
   input(if speed<desired then .45 else 0,if speed>desired+1.5 then .3 else 0,math.clamp(angle*1.8,-.9,.9))
  end
  if os.clock()>nextSample then nextSample=os.clock()+2;local sample={index=index,x=p.X,y=p.Y,z=p.Z,speed=speed,t=os.clock()-started};table.insert(samples,sample);player:SetAttribute("GarageQAProgress",game:GetService("HttpService"):JSONEncode(sample)) end
  task.wait(.08)
 end
 input(0,0,0)
 player:SetAttribute("GarageQAState",reason);player:SetAttribute("GarageQAResult",game:GetService("HttpService"):JSONEncode({reason=reason,index=index,total=#points,visited=visited,elapsed=os.clock()-started,samples=samples}))
end)
return "Queued continuous garage, service street, grass and Cargo QA after roundtrip; no reposition"