-- QA-only (Studio Play Client). B3 Garage City v11 route driver. Never shipped.
-- Drives the existing Street Cub through A-Chassis VirtualInput only: no teleport, CFrame or velocity writes
-- during the drive. Routes are generated from HubLayout (keep-left lanes, 8 studs from road centre).
-- __CASE__ = G1..G6 | CARGO | ROUNDTRIP | SPEEDLANE | GRASS
local CASE="__CASE__"
local HWV=tonumber("__HWV__") or 28 -- highway target speed (B3 default 28; M3 uses 45 and full throttle)
local HttpService=game:GetService("HttpService")
local player=game.Players.LocalPlayer
local L=require(game.ReplicatedStorage.RaceAndRaid.HubLayout)
local city=L.City
local bike=workspace:WaitForChild("Vehicles"):WaitForChild("StreetCub_"..game.Players:GetPlayers()[1].UserId)
local seat=bike:WaitForChild("DriveSeat") :: VehicleSeat
local character=player.Character or player.CharacterAdded:Wait()
local humanoid=character:WaitForChild("Humanoid") :: Humanoid

local function flat(v:Vector3):Vector3 return Vector3.new(v.X,0,v.Z) end
local function leftOf(v:Vector3):Vector3 return Vector3.new(v.Z,0,-v.X) end
local function rotL(v:Vector3,a:number):Vector3 return v*math.cos(a)+leftOf(v)*math.sin(a) end

type Node={p:Vector3,v:number,tag:string?,grass:boolean}
type Sample={p:Vector3,t:Vector3}
local path:{Node}={}
local pos,head=Vector3.zero,Vector3.new(1,0,0)
local curV=14;local grassOK=false
local function emit(p:Vector3,tag:string?) table.insert(path,{p=flat(p),v=curV,tag=tag,grass=grassOK}) end
local function pose(p:Vector3,h:Vector3) pos=flat(p);head=flat(h).Unit end
local function forward(d:number) if d<=0 then return end;local s=pos;local n=math.max(1,math.ceil(d/2));for i=1,n do emit(s+head*(d*i/n)) end;pos=s+head*d end
local function goto(p:Vector3) p=flat(p);local d=p-pos;if d.Magnitude<.5 then return end;head=d.Unit;local s=pos;local n=math.max(1,math.ceil(d.Magnitude/2));for i=1,n do emit(s:Lerp(p,i/n)) end;pos=p end
local function arc(r:number,deg:number,side:number,tag:string?,frac:number?)
 local c=pos+leftOf(head)*side*r;local rel=pos-c;local a=math.rad(deg);local n=math.max(2,math.ceil(r*a/2))
 local tagI=if tag then math.max(1,math.floor(n*(frac or .5))) else -1
 for i=1,n do emit(c+rotL(rel,side*a*i/n),if i==tagI then tag else nil) end
 pos=c+rotL(rel,side*a);head=rotL(head,side*a).Unit
end
local function arcTo(target:Vector3,r:number)
 target=flat(target).Unit;local ang=math.deg(math.acos(math.clamp(head:Dot(target),-1,1)))
 if ang<1 then return end
 arc(r,ang,if target:Dot(leftOf(head))>=0 then 1 else -1)
end
local function follow(samples:{Sample},off:number)
 for _,s in samples do emit(s.p+leftOf(s.t)*off) end
 local last=samples[#samples];pos=flat(last.p+leftOf(last.t)*off);head=flat(last.t).Unit
end
local function reversed(samples:{Sample}):{Sample} local o={};for i=#samples,1,-1 do table.insert(o,{p=samples[i].p,t=-samples[i].t}) end;return o end
local function arcSamples(c:Vector3,rad:number,a0:number,a1:number):{Sample}
 local list={};local n=math.max(2,math.ceil(math.abs(a1-a0)*rad/2));local dir=if a1>a0 then 1 else -1
 for i=0,n do local a=a0+(a1-a0)*i/n;table.insert(list,{p=c+Vector3.new(math.cos(a),0,math.sin(a))*rad,t=Vector3.new(-math.sin(a),0,math.cos(a))*dir}) end
 return list
end
-- ===== road geometry (identical maths to CargoCourse) =====
local FS=city.ForkStartX;local FR,TH=city.ForkRadius,city.ForkTheta;local R=city.CornerRadius;local cornerX=city.BottomX+R
local function forkOut(side:number):{Sample}
 local s=arcSamples(Vector3.new(FS,0,-city.SideZ+FR),FR,-math.pi/2,-math.pi/2+TH)
 local p1=s[#s].p;local dv=Vector3.new(math.cos(TH),0,math.sin(TH))
 local dl=((city.SideZ-city.BranchEndZ)-2*FR*(1-math.cos(TH)))/math.sin(TH);local n=math.ceil(dl/2)
 for i=1,n do table.insert(s,{p=p1+dv*dl*i/n,t=dv}) end
 local p2=p1+dv*dl;local a2=arcSamples(p2+Vector3.new(math.sin(TH),0,-math.cos(TH))*FR,FR,math.pi/2+TH,math.pi/2)
 for i=2,#a2 do table.insert(s,a2[i]) end
 if side==1 then for i,q in s do s[i]={p=Vector3.new(q.p.X,0,-q.p.Z),t=Vector3.new(q.t.X,0,-q.t.Z)} end end
 return s
end
local function cornerBottomToSide(side:number):{Sample}
 if side==-1 then return arcSamples(Vector3.new(cornerX,0,-(city.SideZ-R)),R,math.pi,1.5*math.pi) end
 return arcSamples(Vector3.new(cornerX,0,city.SideZ-R),R,math.pi,.5*math.pi)
end
local function highway(x0:number,x1:number):{Sample}
 local s={};for x=x0,x1,4 do local p=L.RoutePoint(x);table.insert(s,{p=p,t=flat(L.RoutePoint(x+1)-p).Unit}) end;return s
end
local function sideOf(plot):number return if plot.position.Z>0 then 1 else -1 end
local function laneZ(side:number,travelX:number):number return side*city.SideZ-8*travelX end -- +X: z-8, -X: z+8
-- ===== manoeuvres =====
local function garageExit(plot,towards:number) -- towards = +1 (fork/+X) or -1 (bottom/-X)
 local f=L.PlotFrame(plot);local start=f:PointToWorldSpace(L.PlotLocal.BikeStart)
 pose(start,f.LookVector);curV=6
 forward(math.abs(laneZ(sideOf(plot),towards)-start.Z)-35);arcTo(Vector3.new(towards,0,0),35)
end
local function toThroatOut(side:number)
 curV=14;goto(Vector3.new(FS,0,laneZ(side,1)));curV=15;follow(forkOut(side),8);curV=12;goto(Vector3.new(-340,0,-8))
end
local function zone01Keyhole()
 local sx=-235.1
 curV=12;goto(Vector3.new(-300,0,-8));goto(Vector3.new(sx-28,0,-8));curV=6;arcTo(Vector3.new(0,0,-1),28)
 arc(28,40,-1);local i0=#path+1;arc(28,260,1);local i1=#path;arc(28,40,-1)
 local best,bd=i0,math.huge;for i=i0,i1 do local d=(path[i].p-flat(L.Pickup)).Magnitude;if d<bd then bd=d;best=i end end
 path[best].tag="pickup"
 curV=8;goto(Vector3.new(pos.X,0,-20));arcTo(Vector3.new(-1,0,0),28);curV=12;goto(Vector3.new(-340,0,8))
end
-- Cargo variant: the asphalt-only keyhole never comes within the server's 14-stud pickup range, so the
-- player-style route drives straight over the pickup, then U-turns (r30) partly over grass (flagged).
local function zone01PickupTurn()
 curV=12;goto(Vector3.new(-300,0,-8));goto(Vector3.new(-278,0,-8));curV=6;arcTo(Vector3.new(0,0,-1),28)
 goto(Vector3.new(-250,0,-50));emit(Vector3.new(-250,0,-55),"pickup");pos=Vector3.new(-250,0,-55)
 goto(Vector3.new(-250,0,-64))
 grassOK=true;arc(30,180,-1);goto(Vector3.new(pos.X,0,-20));grassOK=false
 curV=8;arcTo(Vector3.new(-1,0,0),28);curV=12;goto(Vector3.new(-340,0,8))
end
local function fromThroatIn(side:number)
 local ins=reversed(forkOut(side));local first=ins[1];curV=12;goto(first.p+leftOf(first.t)*8);curV=15;follow(ins,8)
end
local function garageReturn(plot,travelX:number,deposit:boolean)
 local f=L.PlotFrame(plot);local side=sideOf(plot);local travel=Vector3.new(travelX,0,0)
 local e=28*math.sign(f:VectorToObjectSpace(travel).X)
 local stem=f:PointToWorldSpace(Vector3.new(e,0,0))
 curV=12;goto(Vector3.new(stem.X-travelX*28,0,laneZ(side,travelX)))
 curV=6;arcTo(-f.LookVector,28)
 forward(-30-f:PointToObjectSpace(pos).Z)
 local centreDir=f:VectorToWorldSpace(Vector3.new(-math.sign(e),0,0))
 arc(28,180,if centreDir:Dot(leftOf(head))>=0 then 1 else -1,if deposit then "deposit" else "apex",.5)
 forward(15)
end
-- ===== cases =====
local G1=L.FindPlot("G1")
local limit=300
if string.match(CASE,"^G%d$") then
 local plot=L.FindPlot(CASE);local side=sideOf(plot)
 garageExit(plot,1);toThroatOut(side);zone01Keyhole();fromThroatIn(side);garageReturn(plot,-1,false)
elseif CASE=="CARGO" then
 garageExit(G1,1);toThroatOut(-1);zone01PickupTurn();fromThroatIn(-1);garageReturn(G1,-1,true)
elseif CASE=="ROUNDTRIP" then
 limit=720
 garageExit(G1,1);toThroatOut(-1);curV=14;goto(Vector3.new(-262,0,-8))
 curV=HWV;follow(highway(-250,L.RouteEndX-2),8)
 -- U-turn and lane change both completed inside the EndTurnaround pad (x>=RouteEndX).
 curV=10;forward(70);curV=7;arc(40,180,-1);forward(6);arc(32,90,-1);arc(32,90,1)
 local back=math.floor((pos.X-8)/4)*4
 curV=HWV;follow(reversed(highway(-250,back)),8)
 curV=12;goto(Vector3.new(-340,0,8));fromThroatIn(-1);garageReturn(G1,-1,false)
elseif CASE=="ZONES" then
 -- M3: visit all 12 alternating zones: up the access connector, U-turn on the pad, back to the highway.
 limit=900
 garageExit(G1,1);toThroatOut(-1) -- ends at (-340,-8), before Zone 01's connector
 local x=-250
 for _,z in L.Zones do
  local zx,s,near=z.position.X,z.side,z.padNear
  local road=L.RoutePoint(zx)
  if zx-70>x+4 then curV=HWV;follow(highway(x,zx-70),8) end
  curV=10;goto(Vector3.new(zx-40,0,road.Z+s*10)) -- arc crosses the shoulder->pad band inside the connector
  curV=7;arcTo(Vector3.new(0,0,s),28)
  curV=6;goto(Vector3.new(pos.X,0,road.Z+s*(near+30)));emit(pos,string.format("zone%02d",z.id))
  arcTo(Vector3.new(1,0,0),22);arcTo(Vector3.new(0,0,-s),22) -- exits at zx+32 (connector spans zx+-40)
  goto(Vector3.new(pos.X,0,road.Z+s*20));curV=7;arcTo(Vector3.new(1,0,0),28)
  curV=10;local nx=pos.X+20;goto(Vector3.new(nx,0,L.RoutePoint(nx).Z-8));x=math.ceil(nx/4)*4
 end
elseif CASE=="SPEEDLANE" or CASE=="GRASS" then
 garageExit(G1,-1);curV=14;goto(Vector3.new(cornerX,0,laneZ(-1,-1)));follow(reversed(cornerBottomToSide(-1)),8)
 if CASE=="GRASS" then
  curV=10;goto(Vector3.new(-979,0,32));arcTo(Vector3.new(-1,0,0),28)
  grassOK=true;goto(Vector3.new(-1042,0,60));grassOK=false;goto(Vector3.new(-1066,0,60))
 else
  curV=10;goto(Vector3.new(-979,0,-20));arcTo(Vector3.new(-1,0,0),28)
  -- Keyhole (right 40 / left 260 / right 40) exits 28.2 studs to the LEFT of the entry stem, with the
  -- loop centre 14.1 left: enter south at x=-1046 (exit -1074), north at x=-1074 (exit -1046).
  goto(Vector3.new(-1018,0,8));curV=8;arcTo(Vector3.new(0,0,-1),28)
  curV=26;goto(Vector3.new(-1046,0,-285));curV=6;goto(Vector3.new(-1046,0,-304))
  arc(27,40,-1);arc(27,260,1,"southTurn",.5);arc(27,40,-1)
  curV=26;goto(Vector3.new(pos.X,0,285));curV=6;goto(Vector3.new(pos.X,0,304))
  arc(27,40,-1);arc(27,260,1,"northTurn",.5);arc(27,40,-1)
  curV=20;goto(Vector3.new(pos.X,0,20));curV=8;arcTo(Vector3.new(1,0,0),28)
  arcTo(Vector3.new(0,0,-1),28)
  curV=12;goto(Vector3.new(-995,0,-90));follow(cornerBottomToSide(-1),8)
  garageReturn(G1,1,false)
 end
else error("unknown case "..CASE) end
-- ===== driver =====
local ui=nil
local function control(key:string,v:Vector3,state:Enum.UserInputState?)
 local c=ui.Controls;ui.Drive.VirtualInput:Fire({KeyCode=Enum.KeyCode[c[key].Value],UserInputType=Enum.UserInputType.Gamepad1,UserInputState=state or Enum.UserInputState.Change,Position=v},false)
end
local function steer(v:number) local dz=.15;control("ContlrSteer",Vector3.new(if math.abs(v)<.001 then 0 else math.sign(v)*(dz+(1-dz)*math.abs(v)),0,0)) end
local function throttle(v:number) control("ContlrThrottle",Vector3.new(0,0,v)) end
local function brake(v:number) control("ContlrBrake",Vector3.new(0,0,v)) end
local zt:{[string]:number}={}
local resultKey="B3Result_"..CASE
player:SetAttribute(resultKey,nil)
task.spawn(function()
 local out:{[string]:any}={case=CASE,pathNodes=#path}
 local plen=0;for i=2,#path do plen+=(path[i].p-path[i-1].p).Magnitude end;out.pathLength=math.floor(plen)
 local ok,err=pcall(function()
  -- mount through the real RidePrompt (server validates distance and seats the humanoid)
  local prompt=seat:FindFirstChild("RidePrompt") :: ProximityPrompt
  if humanoid.SeatPart~=seat then prompt:InputHoldBegin();task.wait(.15);prompt:InputHoldEnd() end
  local tm=os.clock();while humanoid.SeatPart~=seat and os.clock()-tm<5 do task.wait(.1) end
  out.mounted=humanoid.SeatPart==seat;if not out.mounted then error("mount failed") end
  ui=player.PlayerGui:WaitForChild("A-Chassis Interface",10);assert(ui,"no A-Chassis Interface")
  -- automatic-transmission check: throttle without any shift input first
  local function gear() local v=ui:FindFirstChild("Values");local g=v and v:FindFirstChild("Gear");return if g then g.Value else "n/a" end
  out.gearAtMount=gear()
  throttle(.7);task.wait(3);out.speedWithoutShift=seat.AssemblyLinearVelocity.Magnitude;throttle(0)
  out.manualShiftNeeded=out.speedWithoutShift<4
  if out.manualShiftNeeded then control("ContlrShiftUp",Vector3.zero,Enum.UserInputState.Begin);control("ContlrShiftUp",Vector3.zero,Enum.UserInputState.End);task.wait(.3) end
  out.gearAfterShift=gear()
  local rp=RaycastParams.new();rp.FilterType=Enum.RaycastFilterType.Exclude;rp.FilterDescendantsInstances={bike,character}
  local idx=1;local t0=os.clock();local lastProg=os.clock();local reason="timeout"
  local st={maxDev=0,devOver6=0,grass=0,unexpectedGrass=0,bumps=0,minUpY=1,maxSpeed=0,ticks=0}
  local events={};local done={};local visited={};local samples={};local nextS=0;local day={}
  local dayConn=player:GetAttributeChangedSignal("G1DayPresetActive"):Connect(function() table.insert(day,{t=math.floor(os.clock()-t0),v=player:GetAttribute("G1DayPresetActive")}) end)
  while true do
   if not seat.Occupant then reason="dismounted";break end
   local p=flat(seat.Position);local vel=seat.AssemblyLinearVelocity;local speed=flat(vel).Magnitude
   local best,bd=idx,math.huge
   for i=idx,math.min(#path,idx+45) do local d=(path[i].p-p).Magnitude;if d<bd then bd=d;best=i end end
   if best>idx then idx=best;lastProg=os.clock() end
   st.ticks+=1;if bd>st.maxDev then st.maxDev=bd;st.worstAt={math.floor(p.X),math.floor(p.Z)} end;if bd>6 then st.devOver6+=1 end;st.maxSpeed=math.max(st.maxSpeed,speed)
   if idx>=#path-1 and bd<6 then reason="complete";break end
   if os.clock()-lastProg>15 then reason="stalled";break end
   if os.clock()-t0>limit then reason="timeout";break end
   -- tagged stops (pickup / deposit / apex / pad turn checkpoints)
   for j=idx,math.min(#path,idx+3) do
    local tag=path[j].tag
    if tag and not done[j] and (path[j].p-p).Magnitude<4.5 then
     done[j]=true
     local ev:{[string]:any}={tag=tag,t=math.floor(os.clock()-t0),pos={math.floor(p.X),math.floor(p.Z)}}
     if tag=="pickup" or tag=="deposit" then
      throttle(0);brake(1);local ts=os.clock();while seat.AssemblyLinearVelocity.Magnitude>1.5 and os.clock()-ts<5 do task.wait(.05) end
      ev.stopSpeed=seat.AssemblyLinearVelocity.Magnitude
      local part=workspace:FindFirstChild(if tag=="pickup" then "TestScrapPickup" else "TestGarageDeposit") :: BasePart
      ev.distToPoint=(flat(seat.Position)-flat(part.Position)).Magnitude
      local pr=part:FindFirstChildOfClass("ProximityPrompt") :: ProximityPrompt
      local before={cargo=player:GetAttribute("TestCargo"),secured=player:GetAttribute("TestSecured")}
      pr:InputHoldBegin();task.wait(pr.HoldDuration+.45);pr:InputHoldEnd()
      local tw=os.clock();while os.clock()-tw<3 do
       if player:GetAttribute("TestCargo")~=before.cargo or player:GetAttribute("TestSecured")~=before.secured then break end;task.wait(.1) end
      ev.before=before;ev.after={cargo=player:GetAttribute("TestCargo"),secured=player:GetAttribute("TestSecured")};ev.message=player:GetAttribute("CargoMessage")
      brake(0);lastProg=os.clock()
     end
     table.insert(events,ev)
    end
   end
   -- pure pursuit
   local Ld=6+.35*speed;local j=idx;local acc=0
   while j<#path and acc<Ld do acc+=(path[j+1].p-path[j].p).Magnitude;j+=1 end
   local tg=path[j].p;local lg=seat.CFrame:PointToObjectSpace(Vector3.new(tg.X,seat.Position.Y,tg.Z))
   steer(math.clamp(math.atan2(lg.X,-lg.Z)*2,-1,1))
   -- speed: segment caps within braking distance + upcoming heading change
   local vcap=path[idx].v;local k=idx;acc=0;local h0=nil;local turn=0
   while k<#path and acc<40 do
    local seg=path[k+1].p-path[k].p;acc+=seg.Magnitude;vcap=math.min(vcap,path[k+1].v)
    if seg.Magnitude>.01 then local h=seg.Unit;if h0==nil then h0=h elseif acc<26 then turn=math.max(turn,math.deg(math.acos(math.clamp(h0:Dot(h),-1,1)))) end end
    k+=1
   end
   if turn>60 then vcap=math.min(vcap,7) elseif turn>30 then vcap=math.min(vcap,10) elseif turn>15 then vcap=math.min(vcap,16) end
   throttle(if speed<vcap then (if vcap>40 then 1 else .7) else 0);brake(if speed>vcap+3 then .35 else 0)
   -- telemetry
   local g=workspace:Raycast(seat.Position,Vector3.new(0,-8,0),rp)
   if g and g.Instance==workspace.Terrain then st.grass+=1;if not path[idx].grass then st.unexpectedGrass+=1 end end
   if math.abs(vel.Y)>4 then st.bumps+=1 end
   st.minUpY=math.min(st.minUpY,seat.CFrame.UpVector.Y);if st.minUpY<.35 then reason="fallen";break end
   for _,z in L.Zones do if (flat(z.position)-p).Magnitude<35 or (flat(z.padCentre)-p).Magnitude<40 then visited[tostring(z.id)]=true end end
   -- first time each zone X is passed outbound (+X) and the gate line X=-330 both ways (timing)
   for _,z in L.Zones do local k=string.format("Z%02d",z.id);if not zt[k] and p.X>=z.position.X then zt[k]=math.floor((os.clock()-t0)*10)/10 end end
   if not zt.gateOut and p.X>=-330 then zt.gateOut=math.floor((os.clock()-t0)*10)/10 end
   if zt.gateOut and not zt.gateIn and p.X<-330 then zt.gateIn=math.floor((os.clock()-t0)*10)/10 end
   if os.clock()>nextS then nextS=os.clock()+4;table.insert(samples,{t=math.floor(os.clock()-t0),x=math.floor(p.X),z=math.floor(p.Z),v=math.floor(speed*10)/10,i=idx}) end
   task.wait(.05)
  end
  dayConn:Disconnect()
  throttle(0);steer(0);brake(1)
  out.zoneTimes=zt;out.reason=reason;out.elapsed=math.floor((os.clock()-t0)*10)/10;out.progress=idx.."/"..#path;out.stats=st;out.events=events
  local vz={};for id in visited do table.insert(vz,tonumber(id)) end;table.sort(vz);out.zonesVisited=vz
  out.garageDay=day;out.samples=samples;out.final={x=math.floor(seat.Position.X),z=math.floor(seat.Position.Z)}
 end)
 if not ok then out.error=tostring(err) end
 player:SetAttribute(resultKey,HttpService:JSONEncode(out))
end)
return "B3 "..CASE.." started: "..#path.." nodes"
