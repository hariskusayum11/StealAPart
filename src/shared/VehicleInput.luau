--!strict
-- C2 Easy Arcade input map: the single source for game vehicle keys and for the A-Chassis controls that
-- the assist remaps at runtime (through the vendor's own Controls StringValues; vendor files untouched).
local VehicleInput = {}

-- Game actions. Mount/Cargo are ProximityPrompts; Wheelie/Tuck/Recover are reserved for C4–C5 and
-- do nothing yet. Mobile/Gamepad entries are the planned bindings, not implemented in C2.
VehicleInput.Actions = {
 Mount = {Keyboard = {Enum.KeyCode.F}, Gamepad = {Enum.KeyCode.ButtonX}, Mobile = "ProximityPrompt"},
 Pickup = {Keyboard = {Enum.KeyCode.E}, Gamepad = {Enum.KeyCode.ButtonX}, Mobile = "ProximityPrompt"},
 Throttle = {Keyboard = {Enum.KeyCode.W, Enum.KeyCode.Up}, Gamepad = {Enum.KeyCode.ButtonR2}, Mobile = "ThrottleButton"},
 Brake = {Keyboard = {Enum.KeyCode.S, Enum.KeyCode.Down}, Gamepad = {Enum.KeyCode.ButtonL2}, Mobile = "BrakeButton"},
 Steer = {Keyboard = {Enum.KeyCode.A, Enum.KeyCode.D, Enum.KeyCode.Left, Enum.KeyCode.Right}, Gamepad = {Enum.KeyCode.Thumbstick1}, Mobile = "SteerPad"},
 Wheelie = {Keyboard = {Enum.KeyCode.Q}, Gamepad = {Enum.KeyCode.ButtonY}, Mobile = "WheelieButton", Reserved = true},
 Tuck = {Keyboard = {Enum.KeyCode.C}, Gamepad = {Enum.KeyCode.ButtonB}, Mobile = "TuckButton", Reserved = true},
 Recover = {Keyboard = {Enum.KeyCode.R}, Gamepad = {Enum.KeyCode.DPadUp}, Mobile = "RecoverButton", Hold = true, Reserved = true},
}

-- Internal keys used only by the assist. No standard PC keyboard or gamepad produces them.
VehicleInput.AssistShiftUpKey = "F13"
VehicleInput.AssistTransModeKey = "Help"
-- Brake is forwarded by the assist (never read directly by the vendor): below LowSpeedBrake the vendor
-- turns a held brake into a backwards "walking" push, so the assist uses the parking brake there instead.
VehicleInput.AssistBrakeKey = "Euro"
VehicleInput.AssistPadBrakeKey = "Undo" -- vendor ContlrBrake parked here; L2 is read by the assist
VehicleInput.AssistParkBrakeKey = "Compose"
VehicleInput.LowSpeedBrake = 3.5
VehicleInput.UserBrakeKeys = {Enum.KeyCode.S, Enum.KeyCode.Down}
VehicleInput.UserThrottleKeys = {Enum.KeyCode.W, Enum.KeyCode.Up}
local SHIFT_DOWN_PARKED = "F14"
VehicleInput.AssistShiftDownKey = SHIFT_DOWN_PARKED -- used only for N while park-held (avoids engine stall)
local DISABLED = "F15"

-- A-Chassis Tune.Controls entry -> runtime value. Throttle/steer keep their vendor defaults; brake goes through the assist
-- (W/S/A/D, arrows, R2/L2/left stick). Everything that changes gear, clutch, mode or toggles is moved
-- off the game keys (F mount, E pickup, Q/C/R tricks, LeftShift, M, P, T/Y/U, gamepad Y/X/R1/L1/D-pad).
VehicleInput.VendorRemap = {
 ShiftUp = VehicleInput.AssistShiftUpKey, MouseShiftUp = VehicleInput.AssistShiftUpKey, ContlrShiftUp = VehicleInput.AssistShiftUpKey,
 ShiftDown = SHIFT_DOWN_PARKED, MouseShiftDown = SHIFT_DOWN_PARKED, ContlrShiftDown = SHIFT_DOWN_PARKED,
 ToggleTransMode = VehicleInput.AssistTransModeKey, ContlrToggleTMode = VehicleInput.AssistTransModeKey,
 Clutch = DISABLED, MouseClutch = DISABLED, ContlrClutch = DISABLED,
 PBrake = VehicleInput.AssistParkBrakeKey, MousePBrake = DISABLED, ContlrPBrake = VehicleInput.AssistParkBrakeKey,
 Brake = VehicleInput.AssistBrakeKey, Brake2 = VehicleInput.AssistBrakeKey, ContlrBrake = VehicleInput.AssistPadBrakeKey,
 ToggleMouseDrive = DISABLED, ToggleTCS = DISABLED, ToggleABS = DISABLED, ToggleCS = DISABLED,
 ContlrToggleTCS = DISABLED, ContlrToggleABS = DISABLED, ContlrToggleCS = DISABLED,
}

-- Roblox default bindings sunk while riding: Space/ButtonA would dismount, Shift would toggle Shift-lock.
VehicleInput.SinkWhileRiding = {
 Jump = {Enum.KeyCode.Space, Enum.KeyCode.ButtonA},
 ShiftLock = {Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift},
}
-- Below this speed Space dismounts as normal (intentional exit while stopped).
VehicleInput.DismountMaxSpeed = 2

return VehicleInput
