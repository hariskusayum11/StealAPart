-- QA-only (Studio Play Client). Runs beside a B3 route drive and records ride-height / lean / suspension
-- extremes and anomaly events until the route result attribute appears. Read-only. Result: RideMonitor.
local player=game.Players.LocalPlayer
local bike=workspace:WaitForChild("Vehicles"):WaitForChild("StreetCub_"..game.Players:GetPlayers()[1].UserId)
local seat=bike:WaitForChild("DriveSeat")
local hum=player.Character:WaitForChild("Humanoid")
local spring={F=bike.Wheels.F:FindFirstChild("Spring",true),R=bike.Wheels.R:FindFirstChild("Spring",true)}
local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={bike,player.Character}
local resultKey="__RESULTKEY__"
player:SetAttribute("RideMonitor",nil)
task.spawn(function()
 local s={n=0,minSeatH=1e9,maxSeatH=-1e9,maxAbsRoll=0,maxAbsPitch=0,minSpringF=1e9,minSpringR=1e9,maxMeshToSeat=0,events={},rollHist={}}
 local lastEvent=0
 local t0=os.clock()
 while not player:GetAttribute(resultKey) and os.clock()-t0<900 do
  if hum.SeatPart==seat then
   s.n+=1
   local cf=seat.CFrame
   local r=workspace:Raycast(seat.Position+Vector3.new(0,3,0),Vector3.new(0,-40,0),params)
   local h=r and seat.Position.Y-r.Position.Y or -1
   local roll=math.deg(math.asin(math.clamp(cf.RightVector.Y,-1,1)));local pitch=math.deg(math.asin(math.clamp(cf.LookVector.Y,-1,1)))
   s.minSeatH=math.min(s.minSeatH,h);s.maxSeatH=math.max(s.maxSeatH,h)
   s.maxAbsRoll=math.max(s.maxAbsRoll,math.abs(roll));s.maxAbsPitch=math.max(s.maxAbsPitch,math.abs(pitch))
   local b=math.floor(math.abs(roll)/5)*5;s.rollHist[tostring(b)]=(s.rollHist[tostring(b)] or 0)+1
   local sf=spring.F and spring.F.CurrentLength or 0;local sr=spring.R and spring.R.CurrentLength or 0
   s.minSpringF=math.min(s.minSpringF,sf);s.minSpringR=math.min(s.minSpringR,sr)
   local md=0;for _,d in bike:GetDescendants() do if d:IsA("BasePart") and d:GetAttribute("BodyFitMesh") then md=math.max(md,(d.Position-seat.Position).Magnitude) end end
   s.maxMeshToSeat=math.max(s.maxMeshToSeat,md)
   local bad=math.abs(roll)>25 or h<1.9 or math.abs(pitch)>12 or (spring.F and sf<=spring.F.MinLength+.03) or (spring.R and sr<=spring.R.MinLength+.03) or md>4.5
   if bad and os.clock()-lastEvent>1 and #s.events<40 then
    lastEvent=os.clock()
    table.insert(s.events,{t=math.floor((os.clock()-t0)*10)/10,x=math.floor(seat.Position.X),z=math.floor(seat.Position.Z),speed=math.floor(seat.AssemblyLinearVelocity.Magnitude*10)/10,roll=math.floor(roll*10)/10,pitch=math.floor(pitch*10)/10,seatH=math.floor(h*100)/100,springF=math.floor(sf*100)/100,springR=math.floor(sr*100)/100,meshToSeat=math.floor(md*10)/10,ground=r and r.Instance.Name or "none"})
   end
  end
  task.wait(.05)
 end
 player:SetAttribute("RideMonitor",game:GetService("HttpService"):JSONEncode(s))
end)
return "ride monitor running for "..resultKey
