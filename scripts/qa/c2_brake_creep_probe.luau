-- QA-only (Studio Play Client, after b3_case_setup). C2: does holding brake ever roll the bike backwards,
-- and does D creep with no input? Reports DISPLACEMENT along the stop heading (not just velocity spikes).
-- __VARIANT__: none | noik (disable rider IKControls, test only) | nocollide (rider parts CanCollide off, test only).
local player=game.Players.LocalPlayer
local seat=workspace:WaitForChild("ChassisTestBike"):WaitForChild("DriveSeat")
local hum=player.Character:WaitForChild("Humanoid")
local prompt=seat:FindFirstChild("RidePrompt");prompt:InputHoldBegin();task.wait(.15);prompt:InputHoldEnd()
local t=os.clock();while hum.SeatPart~=seat and os.clock()-t<5 do task.wait(.05) end
local ui=player.PlayerGui:WaitForChild("A-Chassis Interface",10)
local V=ui:WaitForChild("Values")
local function key(code,state) ui.Drive.VirtualInput:Fire({KeyCode=code,UserInputType=Enum.UserInputType.Keyboard,UserInputState=state,Position=Vector3.zero},false) end
local out={variant="__VARIANT__"}
task.wait(.3)
if "__VARIANT__"=="noik" then for _,d in hum:GetChildren() do if d:IsA("IKControl") then d.Enabled=false end end end
if "__VARIANT__"=="nocollide" then
 game:GetService("RunService").Stepped:Connect(function() for _,d in player.Character:GetDescendants() do if d:IsA("BasePart") then d.CanCollide=false end end end)
end
local F=workspace.ChassisTestBike.Wheels.F
local touching={}
local function track(label,sec)
 local p0=seat.Position;local h=seat.CFrame.LookVector;h=Vector3.new(h.X,0,h.Z).Unit
 local r={minAlong=0,maxAlong=0,maxSpeed=0,minGear=99,series={},maxWheelSpin=0}
 local e=os.clock()+sec;local t0=os.clock();local lastS=0
 while os.clock()<e do
  local along=(seat.Position-p0):Dot(h)
  r.minAlong=math.min(r.minAlong,along);r.maxAlong=math.max(r.maxAlong,along)
  r.maxSpeed=math.max(r.maxSpeed,seat.AssemblyLinearVelocity.Magnitude);r.minGear=math.min(r.minGear,V.Gear.Value)
  r.maxWheelSpin=math.max(r.maxWheelSpin,math.abs((F.AssemblyAngularVelocity-seat.AssemblyAngularVelocity):Dot(F.CFrame.RightVector))*F.Size.Y/2)
  if os.clock()-lastS>=.25 then lastS=os.clock();table.insert(r.series,{math.floor((os.clock()-t0)*100)/100,math.floor(along*100)/100,math.floor(seat.AssemblyLinearVelocity:Dot(h)*100)/100}) end
  task.wait(.03)
 end
 r.final=(seat.Position-p0):Dot(h);out[label]=r
end
-- A) Right after mounting: settle, no input.
track("afterMountNoInput",3)
-- B) Idle in D for 4 s more, no input (creep test).
track("idleInD",4)
-- C) Launch, then hold brake through the stop and 5 s beyond.
key(Enum.KeyCode.W,Enum.UserInputState.Begin);task.wait(2.5);key(Enum.KeyCode.W,Enum.UserInputState.End)
key(Enum.KeyCode.S,Enum.UserInputState.Begin)
local t1=os.clock();while seat.AssemblyLinearVelocity.Magnitude>0.5 and os.clock()-t1<8 do task.wait(.03) end
out.stopTime=os.clock()-t1
track("brakeHeldAfterStop",5)
key(Enum.KeyCode.S,Enum.UserInputState.End)
-- D) Released brake, no input.
track("afterBrakeRelease",4)
out.gear=V.Gear.Value
-- Which rider parts touch non-bike geometry right now (stopped)?
for _,d in player.Character:GetDescendants() do if d:IsA("BasePart") then for _,o in workspace:GetPartsInPart(d) do if not o:IsDescendantOf(player.Character) then touching[d.Name.."->"..(o:IsDescendantOf(workspace.ChassisTestBike) and "bike:" or "world:")..o.Name]=true end end end end
local list={};for k in touching do table.insert(list,k) end;out.riderOverlaps=list
return game:GetService("HttpService"):JSONEncode(out)
