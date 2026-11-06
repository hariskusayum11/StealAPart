-- PLAY-ONLY (B3) Street Cub steady-state turning circle at 28/35 stud/s via A-Chassis virtual input.
-- No velocity/CFrame writes. Circle fitted (Kasa least squares) to seat positions after settling.
local player=game.Players.LocalPlayer
local bike=workspace:WaitForChild("Vehicles"):WaitForChild("StreetCub_"..game.Players:GetPlayers()[1].UserId)
local seat=bike:WaitForChild("DriveSeat") :: VehicleSeat
local ui=player.PlayerGui:WaitForChild("A-Chassis Interface",10)
assert(ui,"not mounted")
local virtual=ui.Drive.VirtualInput
local control=ui:WaitForChild("Controls")
local function send(key,pos,state)
 virtual:Fire({KeyCode=Enum.KeyCode[control[key].Value],UserInputType=Enum.UserInputType.Gamepad1,UserInputState=state or Enum.UserInputState.Change,Position=pos},false)
end
local function steer(v) local dz=.15;send("ContlrSteer",Vector3.new(if math.abs(v)<.001 then 0 else math.sign(v)*(dz+(1-dz)*math.abs(v)),0,0)) end
local function throttle(v) send("ContlrThrottle",Vector3.new(0,0,v)) end
local function brake(v) send("ContlrBrake",Vector3.new(0,0,v)) end
local function fit(pts)
 local n=#pts;if n<10 then return nil end
 local sx,sy,sxx,syy,sxy,sxz,syz,sz=0,0,0,0,0,0,0,0
 for _,q in pts do local x,y=q[1],q[2];local z=x*x+y*y
  sx+=x;sy+=y;sxx+=x*x;syy+=y*y;sxy+=x*y;sxz+=x*z;syz+=y*z;sz+=z end
 -- Solve [sxx sxy sx; sxy syy sy; sx sy n][a b c] = -[sxz syz sz]
 local A={{sxx,sxy,sx,-sxz},{sxy,syy,sy,-syz},{sx,sy,n,-sz}}
 for i=1,3 do local piv=A[i][i];for j=i,4 do A[i][j]/=piv end
  for k=1,3 do if k~=i then local f=A[k][i];for j=i,4 do A[k][j]-=f*A[i][j] end end end end
 local a,b,c=A[1][4],A[2][4],A[3][4]
 local cx,cy=-a/2,-b/2;local r=math.sqrt(math.max(cx*cx+cy*cy-c,0))
 local err=0;for _,q in pts do err=math.max(err,math.abs(math.sqrt((q[1]-cx)^2+(q[2]-cy)^2)-r)) end
 local sweep=0;local prev=nil
 for _,q in pts do local ang=math.atan2(q[2]-cy,q[1]-cx);if prev then local d=ang-prev;if d>math.pi then d-=2*math.pi elseif d< -math.pi then d+=2*math.pi end;sweep+=d end;prev=ang end
 return {radius=r,maxResidual=err,sweepDeg=math.deg(sweep),n=n}
end
player:SetAttribute("TurnQA",nil)
task.spawn(function()
 local results={}
 local ok,e=pcall(function()
  send("ContlrShiftUp",Vector3.zero,Enum.UserInputState.Begin);send("ContlrShiftUp",Vector3.zero,Enum.UserInputState.End)
  local plan={{dir=1,steer=1,v=28},{dir=-1,steer=1,v=28},{dir=1,steer=1,v=35},{dir=-1,steer=1,v=35}}
  for _,s in plan do
   local pts={};local speeds={};local t0=os.clock();local minUp=1;local note="ok"
   while os.clock()-t0<15 do
    if not seat.Occupant then note="dismounted";break end
    local sp=seat.AssemblyLinearVelocity.Magnitude
    steer(s.dir*s.steer);throttle(if sp<s.v then 1 else 0);brake(if sp>s.v+3 then .25 else 0)
    minUp=math.min(minUp,seat.CFrame.UpVector.Y)
    if minUp<.35 then note="fallen";break end
    if os.clock()-t0>6 then table.insert(pts,{seat.Position.X,seat.Position.Z});table.insert(speeds,sp) end
    task.wait(.1)
   end
   local mean=0;for _,v in speeds do mean+=v end;mean=if #speeds>0 then mean/#speeds else 0
   table.insert(results,{dir=s.dir,steerInput=s.steer,targetSpeed=s.v,meanSpeed=mean,fit=fit(pts),minUpY=minUp,note=note})
   if note~="ok" then break end
  end
 end)
 steer(0);throttle(0);brake(1)
 player:SetAttribute("TurnQA",game:GetService("HttpService"):JSONEncode({ok=ok,err=if ok then nil else tostring(e),results=results}))
end)
return "turn measurement running (~95s)"

