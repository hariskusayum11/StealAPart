-- QA-only (Studio Play Client). Background drive for video capture: hold ~__SPEED__ stud/s, optional
-- steer key __STEER__ (A/D or none), for __SECS__ s, then brake. A-Chassis VirtualInput keyboard codes only.
local player=game.Players.LocalPlayer
local seat=workspace:WaitForChild("Vehicles"):WaitForChild("StreetCub_"..game.Players:GetPlayers()[1].UserId):WaitForChild("DriveSeat")
local hum=player.Character:WaitForChild("Humanoid")
if hum.SeatPart~=seat then
 local prompt=seat:FindFirstChild("RidePrompt");prompt:InputHoldBegin();task.wait(.15);prompt:InputHoldEnd()
 local t=os.clock();while hum.SeatPart~=seat and os.clock()-t<5 do task.wait(.05) end
end
local ui=player.PlayerGui:WaitForChild("A-Chassis Interface",10);task.wait(.6)
local function key(code,state) ui.Drive.VirtualInput:Fire({KeyCode=code,UserInputType=Enum.UserInputType.Keyboard,UserInputState=state,Position=Vector3.zero},false) end
if ui.Values.Gear.Value==0 then key(Enum.KeyCode[ui.Controls.ShiftUp.Value],Enum.UserInputState.Begin);key(Enum.KeyCode[ui.Controls.ShiftUp.Value],Enum.UserInputState.End) end
task.spawn(function()
 local steer="__STEER__";local e=os.clock()+__SECS__
 if steer~="none" then key(Enum.KeyCode[steer],Enum.UserInputState.Begin) end
 while os.clock()<e do
  local sp=seat.AssemblyLinearVelocity.Magnitude
  key(Enum.KeyCode.W,if sp<__SPEED__ then Enum.UserInputState.Begin else Enum.UserInputState.End)
  key(Enum.KeyCode.S,if sp>__SPEED__+4 then Enum.UserInputState.Begin else Enum.UserInputState.End)
  task.wait(.05)
 end
 if steer~="none" then key(Enum.KeyCode[steer],Enum.UserInputState.End) end
 key(Enum.KeyCode.W,Enum.UserInputState.End);key(Enum.KeyCode.S,Enum.UserInputState.Begin);task.wait(2.5);key(Enum.KeyCode.S,Enum.UserInputState.End)
end)
task.wait(2.5)
return string.format("driving speed=%.1f gear=%s",seat.AssemblyLinearVelocity.Magnitude,tostring(ui.Values.Gear.Value))
