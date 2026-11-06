--!strict
-- C2 Easy Arcade Auto-Drive. Mount and press W: the assist puts A-Chassis into D, keeps the Auto
-- transmission locked, and moves vendor gear/clutch/mode/toggle keys off the game keys. It works
-- only through the vendor's runtime Controls StringValues and Drive.VirtualInput; A-Chassis files are
-- not modified. No reverse in C2: nothing shifts below 1 and holding brake never selects R.
-- Rollback switch: workspace attribute EasyArcadeDrive = false (checked on each mount).
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local VehicleInput = require(game:GetService("ReplicatedStorage"):WaitForChild("RaceAndRaid"):WaitForChild("VehicleInput"))

local player = Players.LocalPlayer
local SINK_JUMP = "EasyArcadeSinkJump"
local SINK_SHIFT = "EasyArcadeSinkShiftLock"
local PRIORITY = Enum.ContextActionPriority.High.Value + 50

local session = 0 -- increments on every mount/dismount so stale loops stop

local function isChassisSeat(seat: Instance?): boolean
 return seat ~= nil and seat:IsA("VehicleSeat") and seat.Parent ~= nil and seat.Parent:FindFirstChild("A-Chassis Tune") ~= nil
end

local function waitChild(parent: Instance, name: string, timeout: number): Instance?
 local found = parent:FindFirstChild(name)
 if found then return found end
 return parent:WaitForChild(name, timeout)
end

local function fire(virtual: BindableEvent, keyName: string, state: Enum.UserInputState)
 virtual:Fire({KeyCode = (Enum.KeyCode :: any)[keyName], UserInputType = Enum.UserInputType.Keyboard, UserInputState = state, Position = Vector3.zero}, false)
end

local function unbind()
 ContextActionService:UnbindAction(SINK_JUMP)
 ContextActionService:UnbindAction(SINK_SHIFT)
end

local function bindSinks(seat: VehicleSeat)
 -- Space/ButtonA: dismount only when (almost) stopped; while moving the press is consumed.
 ContextActionService:BindActionAtPriority(SINK_JUMP, function(_, state: Enum.UserInputState, _)
  if state == Enum.UserInputState.Begin and seat.AssemblyLinearVelocity.Magnitude <= VehicleInput.DismountMaxSpeed then
   return Enum.ContextActionResult.Pass
  end
  return Enum.ContextActionResult.Sink
 end, false, PRIORITY, table.unpack(VehicleInput.SinkWhileRiding.Jump))
 -- Shift: no Shift-lock toggle while riding (clutch is remapped separately).
 ContextActionService:BindActionAtPriority(SINK_SHIFT, function()
  return Enum.ContextActionResult.Sink
 end, false, PRIORITY, table.unpack(VehicleInput.SinkWhileRiding.ShiftLock))
end

local function onMounted(seat: VehicleSeat, id: number)
 if workspace:GetAttribute("EasyArcadeDrive") == false then return end
 bindSinks(seat)
 local gui = waitChild(player:WaitForChild("PlayerGui"), "A-Chassis Interface", 10)
 if not gui or id ~= session then return end
 local controls = waitChild(gui, "Controls", 10)
 local drive = waitChild(gui, "Drive", 10)
 local values = waitChild(gui, "Values", 10)
 local virtual = drive and waitChild(drive, "VirtualInput", 10)
 local gear = values and waitChild(values, "Gear", 10)
 local mode = values and waitChild(values, "TransmissionMode", 10)
 local isOn = waitChild(gui, "IsOn", 10)
 if not (controls and virtual and gear and mode) or id ~= session then
  warn("EasyArcadeDrive: A-Chassis interface incomplete; assist inactive for this ride")
  return
 end
 local controlsFolder = controls :: Instance
 -- The Drive script creates one StringValue per Tune.Controls entry; wait for the last ones.
 local deadline = os.clock() + 5
 while not controlsFolder:FindFirstChild("ContlrToggleCS") and os.clock() < deadline do task.wait() end
 local remapped, missing = 0, {}
 for name, key in VehicleInput.VendorRemap do
  local value = controlsFolder:FindFirstChild(name)
  if value and value:IsA("StringValue") then
   value.Value = key
   remapped += 1
  else
   table.insert(missing, name)
  end
 end
 if #missing > 0 then warn("EasyArcadeDrive: vendor controls not found: " .. table.concat(missing, ", ")) end
 player:SetAttribute("EasyArcadeRemapped", remapped)
 -- The vendor Ignition plugin hard-codes F/ButtonB: F (our Mount key) would switch the engine OFF while
 -- riding. AutoStart is on, so the ignition key is not needed: stop that LocalScript in this rider's
 -- interface copy (runtime only; vendor files untouched). Stalls are restarted below via IsOn.Starting.
 local ignitionStopped = 0
 for _, d in (gui :: Instance):GetDescendants() do
  if d:IsA("LocalScript") and d.Name == "Ignition" then d.Disabled = true; ignitionStopped += 1 end
 end
 player:SetAttribute("EasyArcadeIgnitionKeyDisabled", ignitionStopped)
 local starting = isOn and isOn:FindFirstChild("Starting")
 local restartUntil = 0
 local virtualEvent = virtual :: BindableEvent
 local gearValue = gear :: IntValue
 local modeValue = mode :: StringValue
 local lastShift, lastMode = 0, 0
 -- Keep Auto + gear >= 1 for the whole ride. ShiftUp is only accepted by the vendor in Auto while
 -- gear < 1, so this never interferes with its own automatic up/down shifting.
 local guiInstance = gui :: Instance
 local pbrake = (values :: Instance):FindFirstChild("PBrake")
 local brakeSent, lastPark = false, 0 -- gamepad L2 is forwarded as a digital brake in C2
 local heldInNeutral = false
 local function userInput(keys: {Enum.KeyCode}, padButton: Enum.KeyCode): number
  if UserInputService:GetFocusedTextBox() then return 0 end
  for _, k in keys do if UserInputService:IsKeyDown(k) then return 1 end end
  for _, state in UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1) do
   if state.KeyCode == padButton then return state.Position.Z end
  end
  return 0
 end
 local function setPark(on: boolean, now: number)
  if pbrake and pbrake:IsA("BoolValue") and pbrake.Value ~= on and now - lastPark > 0.2 then
   lastPark = now -- vendor toggles PBrake on Begin; End only clears it above 5 stud/s
   fire(virtualEvent, VehicleInput.AssistParkBrakeKey, Enum.UserInputState.Begin)
   fire(virtualEvent, VehicleInput.AssistParkBrakeKey, Enum.UserInputState.End)
  end
 end
 while id == session and guiInstance.Parent do
  local now = os.clock()
  -- Brake: pass through while moving; below LowSpeedBrake hold with the parking brake instead, because
  -- the vendor converts a held brake at < 3 stud/s into a backwards push (no reverse in C2).
  local speed = seat.AssemblyLinearVelocity.Magnitude
  local keyBrake = userInput(VehicleInput.UserBrakeKeys, Enum.KeyCode.ButtonL2)
  local throttle = userInput(VehicleInput.UserThrottleKeys, Enum.KeyCode.ButtonR2)
  local lowSpeed = speed < VehicleInput.LowSpeedBrake
  local wantBrake = keyBrake > 0.05 and not lowSpeed
  if wantBrake ~= brakeSent then
   brakeSent = wantBrake
   fire(virtualEvent, VehicleInput.AssistBrakeKey, if wantBrake then Enum.UserInputState.Begin else Enum.UserInputState.End)
  end
  -- Park hold: parking brake + N. In gear the locked wheels drag the RPM to 0 and the vendor stalls
  -- the engine (Tune.Stall), so the hold selects N and the normal D logic below re-engages gear 1 as
  -- soon as brake is released or throttle is pressed.
  local holding = keyBrake > 0.05 and lowSpeed and throttle <= 0.05
  setPark(holding, now)
  player:SetAttribute("EasyArcadeParkHold", holding)
  local engineOn = isOn == nil or not isOn:IsA("BoolValue") or (isOn :: BoolValue).Value
  -- Engine off (stall, or an ignition press that reached the vendor before the plugin was stopped):
  -- request a start through the vendor's own IsOn.Starting flag, then release it.
  if starting and starting:IsA("BoolValue") then
   if not engineOn and not starting.Value and now > restartUntil then
    starting.Value = true
    restartUntil = now + 2
    player:SetAttribute("EasyArcadeRestarts", (player:GetAttribute("EasyArcadeRestarts") or 0) + 1)
   elseif starting.Value and (engineOn or now > restartUntil) then
    starting.Value = false
   end
  end
  if not holding then heldInNeutral = false end
  if holding then
   -- Exactly one ShiftDown per hold: a second one would select R.
   if not heldInNeutral and modeValue.Value == "Auto" and gearValue.Value >= 1 then
    heldInNeutral = true
    lastShift = now
    fire(virtualEvent, VehicleInput.AssistShiftDownKey, Enum.UserInputState.Begin)
    fire(virtualEvent, VehicleInput.AssistShiftDownKey, Enum.UserInputState.End)
   end
  elseif modeValue.Value ~= "Auto" then
   if now - lastMode > 0.3 then
    lastMode = now
    fire(virtualEvent, VehicleInput.AssistTransModeKey, Enum.UserInputState.Begin)
    fire(virtualEvent, VehicleInput.AssistTransModeKey, Enum.UserInputState.End)
   end
  elseif engineOn and gearValue.Value < 1 and now - lastShift > 0.15 then
   lastShift = now
   fire(virtualEvent, VehicleInput.AssistShiftUpKey, Enum.UserInputState.Begin)
   fire(virtualEvent, VehicleInput.AssistShiftUpKey, Enum.UserInputState.End)
   player:SetAttribute("EasyArcadeAutoShifts", (player:GetAttribute("EasyArcadeAutoShifts") or 0) + 1)
  end
  RunService.Heartbeat:Wait()
 end
end

local function watch(character: Model)
 local humanoid = character:WaitForChild("Humanoid", 10)
 if not humanoid or not humanoid:IsA("Humanoid") then return end
 local function update()
  session += 1
  unbind()
  local seat = humanoid.SeatPart
  if seat and isChassisSeat(seat) then
   task.spawn(onMounted, seat :: VehicleSeat, session)
  end
 end
 humanoid:GetPropertyChangedSignal("SeatPart"):Connect(update)
 update()
end

player.CharacterAdded:Connect(watch)
if player.Character then task.spawn(watch, player.Character) end
player.CharacterRemoving:Connect(function() session += 1; unbind() end)
