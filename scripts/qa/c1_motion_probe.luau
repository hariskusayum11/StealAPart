-- QA-only (Studio Play Client). C1 body-fit follow check while really driving (A-Chassis VirtualInput,
-- keyboard W/A/D/S path; no CFrame/velocity writes). Run after b3_case_setup. Never shipped.
-- Reports, per mesh group, drift from its weld target (must stay ~0), fork steer angle and wheel spin
-- (must change), maximum mesh-to-seat distance and minimum UpVector.Y.
local player=game.Players.LocalPlayer
local bike=workspace:WaitForChild("ChassisTestBike")
local seat=bike:WaitForChild("DriveSeat")
local hum=player.Character:WaitForChild("Humanoid")
local F=bike.Wheels.F;local R=bike.Wheels.R
local function find(parent,name) return parent:FindFirstChild(name,true) end
local shell=find(bike.Body,"chassis") or bike.Body.BodyFitMesh:FindFirstChildWhichIsA("BasePart")
local forks=find(F.Fixed,"forks_front");local wf=find(F.Parts,"wheel_front");local wr=find(R.Parts,"wheel_rear");local fr=find(R.WheelFixed,"forks_rear")
local pairs_={{"shell→DriveSeat",shell,seat},{"forks_front→F.Arm",forks,F.Arm},{"wheel_front→F",wf,F},{"wheel_rear→R",wr,R},{"forks_rear→R.Axle",fr,R.Axle}}
local function ang(cf) local _,a=cf:ToAxisAngle();return math.deg(math.abs(a)) end
local base={};for i,p in pairs_ do base[i]=p[3].CFrame:ToObjectSpace(p[2].CFrame) end
local forkRest=seat.CFrame:ToObjectSpace(forks.CFrame)
local out={groups={},mounted=false}
local prompt=seat:FindFirstChild("RidePrompt");prompt:InputHoldBegin();task.wait(.15);prompt:InputHoldEnd()
local t=os.clock();while hum.SeatPart~=seat and os.clock()-t<5 do task.wait(.1) end
out.mounted=hum.SeatPart==seat
local ui=player.PlayerGui:WaitForChild("A-Chassis Interface",10)
task.wait(1)
local function key(name,state) ui.Drive.VirtualInput:Fire({KeyCode=Enum.KeyCode[ui.Controls[name].Value],UserInputType=Enum.UserInputType.Keyboard,UserInputState=state,Position=Vector3.zero},false) end
out.gearAtMount=ui.Values.Gear.Value
if "__SHIFT__"=="1" and ui.Values.Gear.Value==0 then key("ShiftUp",Enum.UserInputState.Begin);key("ShiftUp",Enum.UserInputState.End) end
local drift={0,0,0,0,0};local driftPos={0,0,0,0,0}
local maxSteer,maxD,minUp,maxSpeed=0,0,1,0
local spin=0;local prevSpin=nil
local start=seat.Position
local function sample()
 for i,p in pairs_ do
  local rel=base[i]:ToObjectSpace(p[3].CFrame:ToObjectSpace(p[2].CFrame))
  drift[i]=math.max(drift[i],ang(rel));driftPos[i]=math.max(driftPos[i],rel.Position.Magnitude)
 end
 maxSteer=math.max(maxSteer,ang(forkRest:ToObjectSpace(seat.CFrame:ToObjectSpace(forks.CFrame))))
 local s=F.Arm.CFrame:ToObjectSpace(wf.CFrame);if prevSpin then spin+=ang(prevSpin:ToObjectSpace(s)) end;prevSpin=s
 for _,d in bike:GetDescendants() do if d:IsA("BasePart") and d:GetAttribute("BodyFitMesh") then maxD=math.max(maxD,(d.Position-seat.Position).Magnitude) end end
 minUp=math.min(minUp,seat.CFrame.UpVector.Y);maxSpeed=math.max(maxSpeed,seat.AssemblyLinearVelocity.Magnitude)
end
local function run(sec) local e=os.clock()+sec;while os.clock()<e do sample();task.wait(.05) end end
key("Throttle2",Enum.UserInputState.Begin);run(2.5)
key("SteerLeft2",Enum.UserInputState.Begin);run(1.5);key("SteerLeft2",Enum.UserInputState.End)
key("SteerRight2",Enum.UserInputState.Begin);run(1.5);key("SteerRight2",Enum.UserInputState.End)
key("Throttle2",Enum.UserInputState.End);key("Brake2",Enum.UserInputState.Begin);run(2.5);key("Brake2",Enum.UserInputState.End)
for i,p in pairs_ do out.groups[p[1]]={maxDriftDeg=drift[i],maxDriftStuds=driftPos[i]} end
local anchored,n=0,0;for _,d in bike:GetDescendants() do if d:IsA("BasePart") and d:GetAttribute("BodyFitMesh") then n+=1;if d.Anchored then anchored+=1 end end end
out.meshes=n;out.anchored=anchored;out.maxForkSteerDeg=maxSteer;out.frontWheelSpinDeg=spin;out.maxMeshToSeat=maxD
out.minUpY=minUp;out.maxSpeed=maxSpeed;out.travelled=(seat.Position-start).Magnitude;out.bodyFitVersion=bike:GetAttribute("BodyFitVersion")
out.assemblyMass=seat.AssemblyMass
return game:GetService("HttpService"):JSONEncode(out)
