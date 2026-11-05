-- QA-only: continuous manoeuvres from the bike's current position; never reposition it.
local p=game.Players.LocalPlayer
local seat=workspace.ChassisTestBike.DriveSeat
local ui=p.PlayerGui:FindFirstChild("A-Chassis Interface");assert(ui,"Mount Street Cub first")
local v=ui.Drive.VirtualInput;local controls=ui.Controls
local function key(k,pos,state) v:Fire({KeyCode=Enum.KeyCode[controls[k].Value],UserInputType=Enum.UserInputType.Gamepad1,UserInputState=state or Enum.UserInputState.Change,Position=pos},false) end
local function drive(t,b,s)
 key("ContlrThrottle",Vector3.new(0,0,t));key("ContlrBrake",Vector3.new(0,0,b));key("ContlrSteer",Vector3.new(if math.abs(s)<.001 then 0 else math.sign(s)*(.15+.85*math.abs(s)),0,0))
end
local function gear(target)
 drive(0,.3,0)
 for _=1,5 do
  local g=ui.Values.Gear.Value;if g==target then drive(0,0,0);return true end
  local k=if g>target then "ContlrShiftDown" else "ContlrShiftUp"
  key(k,Vector3.zero,Enum.UserInputState.Begin);task.wait(.12);key(k,Vector3.zero,Enum.UserInputState.End);task.wait(.3)
 end
 return false
end
local points={}
local function add(x,z,reverse,tag) table.insert(points,{position=Vector3.new(x,0,z),reverse=reverse==true,tag=tag}) end
add(-772,60,true)
for _,cx in {-760,-640,-520} do add(cx-12,60);add(cx-12,104,false,"entered-"..cx);add(cx-12,60,true,"garage-"..cx) end
add(-440,35);add(-440,-35)
for _,cx in {-520,-640,-760} do add(cx+12,-60);add(cx+12,-104,false,"entered-"..cx.."south");add(cx+12,-60,true,"garage-"..cx.."south") end
add(-830,-35);add(-900,0);add(-1040,0);add(-1040,220);add(-709,220);add(-709,155);add(-709,90);add(-709,50,false,"service-road");add(-680,25);add(-640,0)
for x=-620,-420,10 do add(x,40*math.sin(math.pi*(x+620)/200)^2,false,if x==-520 then "grass" else nil) end
add(-300,0);add(-250,-10);add(-250,-35);add(-250,-55,false,"pickup")
add(-250,-35,true);add(-250,-10,true);add(-290,0,true)
for x=-320,-720,-20 do add(x,0) end
add(-748,5);add(-760,25);add(-760,60);add(-760,84,false,"deposit")
p:SetAttribute("GarageQAState","running")
task.spawn(function()
 local visited={};local samples={};local index=1;local start=os.clock();local last=os.clock();local best=math.huge;local nextSample=0;local mode=nil;local reason="timeout"
 while os.clock()-start<1200 do
  if not seat.Occupant then reason="dismounted";break end
  if index>#points then reason="complete";break end
  local point=points[index];local target=point.position
  if mode~=point.reverse then if not gear(if point.reverse then -1 else 1) then reason="gear-selection-failed";break end;mode=point.reverse end
  local pos=seat.Position;local speed=seat.AssemblyLinearVelocity.Magnitude;local dist=Vector3.new(pos.X-target.X,0,pos.Z-target.Z).Magnitude
  if dist<best-1 then best=dist;last=os.clock() end
  if dist<3 then
   if point.tag=="pickup" or point.tag=="deposit" then
    local tag=point.tag;p:SetAttribute("GarageQAState","await-"..tag);local waitStart=os.clock()
    while os.clock()-waitStart<90 do
     drive(0,if seat.AssemblyLinearVelocity.Magnitude>.5 then .4 else 0,0)
     if (tag=="pickup" and (p:GetAttribute("TestCargo") or 0)>0) or (tag=="deposit" and (p:GetAttribute("TestSecured") or 0)>0) then break end
     task.wait(.1)
    end
    if os.clock()-waitStart>=90 then reason=tag.."-input-timeout";break end
    p:SetAttribute("GarageQAState","running")
   end
   if point.tag then visited[point.tag]=true end
   index+=1;best=math.huge;last=os.clock()
  else
   if os.clock()-last>25 then reason="stalled";break end
   local d=seat.CFrame:PointToObjectSpace(Vector3.new(target.X,pos.Y,target.Z))
   local angle=math.atan2(d.X,if point.reverse then d.Z else -d.Z)
   local desired=if point.reverse then 3.5 elseif math.abs(angle)>.35 then 4 else 7
   if index<22 then desired=math.min(desired,4.5) end
   drive(if speed<desired then .4 else 0,if speed>desired+1 then .35 else 0,math.clamp(angle*1.6,-.9,.9))
  end
  if os.clock()>nextSample then nextSample=os.clock()+2;local row={index=index,x=pos.X,y=pos.Y,z=pos.Z,speed=speed,gear=ui.Values.Gear.Value,t=os.clock()-start};table.insert(samples,row);p:SetAttribute("GarageQAProgress",game:GetService("HttpService"):JSONEncode(row)) end
  task.wait(.08)
 end
 drive(0,0,0);p:SetAttribute("GarageQAState",reason);p:SetAttribute("GarageQAResult",game:GetService("HttpService"):JSONEncode({reason=reason,index=index,total=#points,visited=visited,elapsed=os.clock()-start,samples=samples}))
end)
return "Garage manoeuvre QA uses forward entry/reverse exit, like a garage; existing failed turn-in-place test retained separately"