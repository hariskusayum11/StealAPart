-- QA-only (Studio Play Client, after b3_case_setup). Read-only physics/appearance probe for C1 review:
-- wheel-mesh axis vs real hinge axis (wobble), ride height / pitch / roll / suspension (collapse) and
-- rider offset (alignment). Drives with A-Chassis VirtualInput keyboard codes; no CFrame/velocity writes.
-- __SHIFT__="1" fires ShiftUp when the build starts in N (pre-C2 builds).
local player=game.Players.LocalPlayer
local bike=workspace:WaitForChild("ChassisTestBike")
local seat=bike:WaitForChild("DriveSeat")
local hum=player.Character:WaitForChild("Humanoid")
local root=player.Character:WaitForChild("HumanoidRootPart")
local W={F=bike.Wheels.F,R=bike.Wheels.R}
local mesh={F=bike.Wheels.F:FindFirstChild("wheel_front",true),R=bike.Wheels.R:FindFirstChild("wheel_rear",true)}
local hinge={F=bike.Wheels.F:FindFirstChild("#AV"),R=bike.Wheels.R:FindFirstChild("#AV")}
local spring={F=bike.Wheels.F:FindFirstChild("Spring",true),R=bike.Wheels.R:FindFirstChild("Spring",true)}
local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={bike,player.Character}
local function ground(p) local r=workspace:Raycast(p+Vector3.new(0,3,0),Vector3.new(0,-30,0),params);return r and (p.Y-r.Position.Y) or -1 end
local function deg(x) return math.deg(x) end
local function axisAngle(a,b) return deg(math.acos(math.clamp(math.abs(a.Unit:Dot(b.Unit)),0,1))) end
-- Static geometry (any state): where is each axle and how is each display mesh aligned to it.
local function geometry(k)
 local h=hinge[k];local wheel=W[k];local m=mesh[k]
 local axis=h and h.Attachment0 and h.Attachment0.WorldAxis or wheel.CFrame.RightVector
 local pivot=h and h.Attachment1 and h.Attachment1.WorldPosition or wheel.Position
 local g={wheelShape=wheel:IsA("Part") and wheel.Shape.Name or wheel.ClassName,wheelSize=tostring(wheel.Size)}
 g.physWheelAxisVsHinge=axisAngle(wheel.CFrame.RightVector,axis)
 g.physWheelCentreOffAxis=((wheel.Position-pivot):Cross(axis.Unit)).Magnitude
 if m then
  -- The mesh axle is its thinnest local axis.
  local s=m.Size;local ax=if s.X<=s.Y and s.X<=s.Z then m.CFrame.RightVector elseif s.Y<=s.Z then m.CFrame.UpVector else m.CFrame.LookVector
  g.meshSize=tostring(s);g.meshAxleVsHinge=axisAngle(ax,axis);g.meshCentreOffAxis=((m.Position-pivot):Cross(axis.Unit)).Magnitude
  g.meshCentreAlongAxis=(m.Position-pivot):Dot(axis.Unit)
  g.meshRimWobbleStuds=math.max(s.Y,s.Z,s.X)/2*math.sin(math.rad(g.meshAxleVsHinge))
  g.anchored=m.Anchored;g.joints=#m:GetJoints()
 end
 return g
end
local out={rest={F=geometry("F"),R=geometry("R")}}
local prompt=seat:FindFirstChild("RidePrompt");prompt:InputHoldBegin();task.wait(.15);prompt:InputHoldEnd()
local t=os.clock();while hum.SeatPart~=seat and os.clock()-t<5 do task.wait(.05) end
out.mounted=hum.SeatPart==seat
local ui=player.PlayerGui:WaitForChild("A-Chassis Interface",10);task.wait(1)
local function key(code,state) ui.Drive.VirtualInput:Fire({KeyCode=code,UserInputType=Enum.UserInputType.Keyboard,UserInputState=state,Position=Vector3.zero},false) end
local function ctl(name,state) key(Enum.KeyCode[ui.Controls[name].Value],state) end
if "__SHIFT__"=="1" and ui.Values.Gear.Value==0 then ctl("ShiftUp",Enum.UserInputState.Begin);ctl("ShiftUp",Enum.UserInputState.End) end
local function stats() return {n=0,seatH={1e9,-1e9},pitch={1e9,-1e9},roll={1e9,-1e9},springF={1e9,-1e9},springR={1e9,-1e9},seatToFWheelY={1e9,-1e9},seatToRWheelY={1e9,-1e9},riderY={1e9,-1e9},riderX={1e9,-1e9},meshAxleF=0,meshAxleR=0,meshOffF=0,meshOffR=0,speed={1e9,-1e9}} end
local function mm(r,v) r[1]=math.min(r[1],v);r[2]=math.max(r[2],v) end
local function sample(s)
 s.n+=1
 local cf=seat.CFrame
 mm(s.seatH,ground(seat.Position));mm(s.speed,seat.AssemblyLinearVelocity.Magnitude)
 local flatLook=Vector3.new(cf.LookVector.X,0,cf.LookVector.Z).Unit
 mm(s.pitch,deg(math.asin(math.clamp(cf.LookVector.Y,-1,1))))
 mm(s.roll,deg(math.asin(math.clamp(cf.RightVector.Y,-1,1))))
 if spring.F then mm(s.springF,spring.F.CurrentLength) end;if spring.R then mm(s.springR,spring.R.CurrentLength) end
 mm(s.seatToFWheelY,cf:PointToObjectSpace(W.F.Position).Y);mm(s.seatToRWheelY,cf:PointToObjectSpace(W.R.Position).Y)
 local rp=cf:PointToObjectSpace(root.Position);mm(s.riderY,rp.Y);mm(s.riderX,rp.X)
 local gF,gR=geometry("F"),geometry("R")
 s.meshAxleF=math.max(s.meshAxleF,gF.meshAxleVsHinge or 0);s.meshAxleR=math.max(s.meshAxleR,gR.meshAxleVsHinge or 0)
 s.meshOffF=math.max(s.meshOffF,gF.meshCentreOffAxis or 0);s.meshOffR=math.max(s.meshOffR,gR.meshCentreOffAxis or 0)
 local _=flatLook
end
local function phase(label,sec,throttle,steer,target)
 local s=stats();local e=os.clock()+sec
 if steer then key(steer,Enum.UserInputState.Begin) end
 while os.clock()<e do
  local sp=seat.AssemblyLinearVelocity.Magnitude
  local want=throttle and (not target or sp<target)
  key(Enum.KeyCode.W,if want then Enum.UserInputState.Begin else Enum.UserInputState.End)
  if target and sp>target+3 then key(Enum.KeyCode.S,Enum.UserInputState.Begin) else key(Enum.KeyCode.S,Enum.UserInputState.End) end
  sample(s);task.wait(.05)
 end
 if steer then key(steer,Enum.UserInputState.End) end
 key(Enum.KeyCode.W,Enum.UserInputState.End);key(Enum.KeyCode.S,Enum.UserInputState.End)
 out[label]=s
end
phase("seated_still",2,false)
phase("low_10",5,true,nil,10)
phase("mid_25",5,true,nil,25)
phase("high_max",5,true,nil,nil)
phase("turn_20",5,true,Enum.KeyCode.A,20)
key(Enum.KeyCode.S,Enum.UserInputState.Begin);phase("braking",3,false);key(Enum.KeyCode.S,Enum.UserInputState.End)
if spring.F then out.springLimits={F={free=spring.F.FreeLength,min=spring.F.MinLength,max=spring.F.MaxLength},R=spring.R and {free=spring.R.FreeLength,min=spring.R.MinLength,max=spring.R.MaxLength}} end
out.bodyFitVersion=bike:GetAttribute("BodyFitVersion");out.assemblyMass=seat.AssemblyMass
return game:GetService("HttpService"):JSONEncode(out)
