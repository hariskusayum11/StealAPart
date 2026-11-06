-- QA-only (Studio Play Client). Background recorder for the C2 real-keyboard test: the key presses come
-- from StudioMCP user_keyboard_input (real input pipeline), this script only observes. For every key
-- press it logs the state at the press and 0.6 s later; it also tracks launch time, brake-hold
-- displacement and on-foot movement. Result JSON -> player attribute C2Keys after __SECS__ s.
local UIS=game:GetService("UserInputService")
local player=game.Players.LocalPlayer
local seat=workspace:WaitForChild("ChassisTestBike"):WaitForChild("DriveSeat")
local char=player.Character;local hum=char:WaitForChild("Humanoid");local root=char:WaitForChild("HumanoidRootPart")
player:SetAttribute("C2Keys",nil)
local t0=os.clock()
local function r2(x) return math.floor(x*100+.5)/100 end
local function values() local ui=player.PlayerGui:FindFirstChild("A-Chassis Interface");return ui and ui:FindFirstChild("Values") end
local function state()
 local v=values()
 return {t=r2(os.clock()-t0),seated=hum.SeatPart==seat,speed=r2(seat.AssemblyLinearVelocity.Magnitude),
  gear=if v then v.Gear.Value else "n/a",mode=if v then v.TransmissionMode.Value else "n/a",pbrake=if v then v.PBrake.Value else "n/a",
  tcs=if v then v.TCS.Value else "n/a",inThrot=if v then r2(v.InputThrottle.Value) else "n/a",inBrake=if v then r2(v.InputBrake.Value) else "n/a",
  brake=if v then r2(v.Brake.Value) else "n/a",rpm=if v then math.floor(v.RPM.Value) else "n/a",isOn=(function() local ui=player.PlayerGui:FindFirstChild("A-Chassis Interface");local o=ui and ui:FindFirstChild("IsOn");return if o then o.Value else "n/a" end)(),mouse=UIS.MouseBehavior.Name,hstate=hum:GetState().Name,root={r2(root.Position.X),r2(root.Position.Z)}}
end
local out={minGearSeen=99,events={},launch={},brakeHold={},walk={},jumpSeen=false,timeline={}}
local wDown,sDown=nil,nil
local stopRef=nil;local heading=nil
UIS.InputBegan:Connect(function(input)
 if input.UserInputType~=Enum.UserInputType.Keyboard then return end
 local k=input.KeyCode.Name;local before=state()
 if k=="W" then wDown=os.clock();if before.seated then table.insert(out.launch,{t=before.t,gear=before.gear,timeTo6=nil}) else out.walk.start={root=before.root,t=before.t} end end
 if k=="S" then sDown=os.clock();stopRef=nil;heading=Vector3.new(seat.CFrame.LookVector.X,0,seat.CFrame.LookVector.Z).Unit;table.insert(out.brakeHold,{t=before.t,minAlongAfterStop=0,stopped=false}) end
 task.delay(.6,function() table.insert(out.events,{key=k,before=before,after=state()}) end)
end)
UIS.InputEnded:Connect(function(input)
 local k=input.KeyCode.Name
 if k=="W" then wDown=nil;if out.walk.start and not out.walk["end"] and hum.SeatPart==nil then local s=state();out.walk["end"]={root=s.root,t=s.t} end end
 if k=="S" then sDown=nil end
end)
hum.StateChanged:Connect(function(_,new) if new==Enum.HumanoidStateType.Jumping and hum.SeatPart==nil then out.jumpSeen=true end end)
task.spawn(function()
 while os.clock()-t0<__SECS__ do
  local sp=seat.AssemblyLinearVelocity.Magnitude
  if wDown and hum.SeatPart==seat then local l=out.launch[#out.launch];if l and not l.timeTo6 and sp>=6 then l.timeTo6=r2(os.clock()-wDown) end end
  if sDown and hum.SeatPart==seat then
   local b=out.brakeHold[#out.brakeHold]
   if not stopRef and sp<0.5 then stopRef=seat.Position;b.stopped=true;b.stopAfter=r2(os.clock()-sDown) end
   if stopRef then local a=(seat.Position-stopRef):Dot(heading);b.minAlongAfterStop=r2(math.min(b.minAlongAfterStop,a));b.maxAlongAfterStop=r2(math.max(b.maxAlongAfterStop or 0,a)) end
   local v=values();if v and v.PBrake.Value then b.parkHoldSeen=true end
  end
  do local v=values();if v and hum.SeatPart==seat then out.minGearSeen=math.min(out.minGearSeen,v.Gear.Value) end end
  if hum.SeatPart==seat and os.clock()-(out._lt or 0)>=.25 then out._lt=os.clock();local s=state();table.insert(out.timeline,{s.t,s.speed,s.inThrot,s.inBrake,s.brake,s.pbrake,s.rpm,s.gear,s.isOn}) end
  task.wait(.03)
 end
 out._lt=nil
 out.final=state()
 player:SetAttribute("C2Keys",game:GetService("HttpService"):JSONEncode(out))
end)
return "recorder running "..tostring(__SECS__).." s"
