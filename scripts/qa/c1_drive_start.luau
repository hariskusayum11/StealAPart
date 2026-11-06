-- QA-only (Studio Play Client). Mount via RidePrompt and hold throttle (keyboard W path via VirtualInput)
-- so a screenshot can be taken while moving. __SHIFT__ = "1" fires ShiftUp (pre-C2 builds start in N).
local player=game.Players.LocalPlayer
local bike=workspace:WaitForChild("ChassisTestBike")
local seat=bike:WaitForChild("DriveSeat")
local hum=player.Character:WaitForChild("Humanoid")
local root=player.Character:WaitForChild("HumanoidRootPart")
-- Character placement is done beforehand by b3_case_setup (server).

local prompt=seat:FindFirstChild("RidePrompt");prompt:InputHoldBegin();task.wait(.15);prompt:InputHoldEnd()
local t=os.clock();while hum.SeatPart~=seat and os.clock()-t<5 do task.wait(.1) end
local ui=player.PlayerGui:WaitForChild("A-Chassis Interface",10)
task.wait(1)
local function key(name,state) ui.Drive.VirtualInput:Fire({KeyCode=Enum.KeyCode[ui.Controls[name].Value],UserInputType=Enum.UserInputType.Keyboard,UserInputState=state,Position=Vector3.zero},false) end
if "__SHIFT__"=="1" then key("ShiftUp",Enum.UserInputState.Begin);key("ShiftUp",Enum.UserInputState.End) end
key("Throttle2",Enum.UserInputState.Begin)
task.wait(__HOLD__)
return string.format("mounted=%s gear=%s speed=%.1f seat=%s",tostring(hum.SeatPart==seat),tostring(ui.Values.Gear.Value),seat.AssemblyLinearVelocity.Magnitude,tostring(seat.Position))
