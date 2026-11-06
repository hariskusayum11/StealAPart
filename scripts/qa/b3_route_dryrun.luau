-- QA-only (Studio Play Server). Dry run of a B3 route: builds the exact path and raycasts every node from
-- above, listing nodes whose top surface is Terrain (grass). No driving. __CASE__ as in b3_route_driver.
local CASE="__CASE__"
local HttpService=game:GetService("HttpService")
local L=require(game.ReplicatedStorage.RaceAndRaid.HubLayout)
local city=L.City
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
 curV=28;follow(highway(-250,L.RouteEndX-2),8)
 -- U-turn and lane change both completed inside the EndTurnaround pad (x>=RouteEndX).
 curV=10;forward(70);curV=7;arc(40,180,-1);forward(6);arc(32,90,-1);arc(32,90,1)
 local back=math.floor((pos.X-8)/4)*4
 curV=28;follow(reversed(highway(-250,back)),8)
 curV=12;goto(Vector3.new(-340,0,8));fromThroatIn(-1);garageReturn(G1,-1,false)
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
local rp=RaycastParams.new();rp.FilterType=Enum.RaycastFilterType.Exclude;rp.FilterDescendantsInstances={(workspace:FindFirstChild("Vehicles") and workspace.Vehicles:FindFirstChild("StreetCub_"..game.Players:GetPlayers()[1].UserId))}
local grass={};local runs={};local cur=nil
for i,n in path do
 local hit=workspace:Raycast(n.p+Vector3.new(0,300,0),Vector3.new(0,-600,0),rp)
 local onGrass=hit and hit.Instance==workspace.Terrain
 if onGrass and not n.grass then
  if not cur then cur={from=i,x1=math.floor(n.p.X),z1=math.floor(n.p.Z)} end
  cur.to=i;cur.x2=math.floor(n.p.X);cur.z2=math.floor(n.p.Z)
 elseif cur then table.insert(runs,cur);cur=nil end
end
if cur then table.insert(runs,cur) end
return HttpService:JSONEncode({case=CASE,nodes=#path,unexpectedGrassRuns=runs})